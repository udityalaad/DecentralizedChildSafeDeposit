// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract ChildSafeDeposite {
    address private _child;
    address private _parent1;
    address private _parent2;
    address private _observer1;
    address private _observer2;

    uint256 private _childEligibilityTimestamp;
    uint256 private _parentEligibilityTimestamp;
    uint256 private _observerEligibilityTimestamp;

    mapping(address => uint256) private _childOrParentEmergencyWithdrawalAllowanceByObservers;
    uint256 private _parentEmergencyWithdrawalAllowanceByChild;

    uint256 _lastEmergencyWithrawalByChild_timestamp;
    uint256 _lastEmergencyWithrawalByParent_timestamp;

    uint256 _emergencyWithdrawal_globalLimit;
    
    uint public constant MIN_REQUIRED_TIME_LAPSE_BEFORE_EMERGENCY_WITHDRAWAL = 1 * 86400;                  //  Day(s) * SecondsPerDay
    uint public constant MIN_REQUIRED_DIFF_BETWEEN_CHILD_AND_PARENT_ELIGIBILITY = 1 * 365 * 86400;         //  Year(s) * DaysPerYear * SecondsPerDay
    uint public constant MIN_REQUIRED_DIFF_BETWEEN_PARENT_AND_OBSERVER_ELIGIBILITY = 2 * 365 * 86400;      //  Year(s) * DaysPerYear * SecondsPerDay

    constructor (
            address child,
            address parent1,
            address parent2,
            address observer1,
            address observer2,
            uint256 childEligibilityTimestamp,
            uint256 parentEligibilityTimestamp,
            uint256 observerEligibilityTimestamp,
            uint256 emergencyWithdrawal_globalLimit
    ) payable {
        _child = child;
        _parent1 = parent1;
        _parent2 = parent2;
        _observer1 = observer1;
        _observer2 = observer2;

        require(childEligibilityTimestamp > block.timestamp,
                "childEligibilityTimestamp must be in the future");
        require(parentEligibilityTimestamp > MIN_REQUIRED_DIFF_BETWEEN_CHILD_AND_PARENT_ELIGIBILITY + childEligibilityTimestamp,
                string.concat("Parent-Eligibility must be atleast ", Strings.toString(MIN_REQUIRED_DIFF_BETWEEN_CHILD_AND_PARENT_ELIGIBILITY), " ahead compared to child"));
        require(observerEligibilityTimestamp > MIN_REQUIRED_DIFF_BETWEEN_PARENT_AND_OBSERVER_ELIGIBILITY + parentEligibilityTimestamp,
                string.concat("Observer-Eligibility must be atleast ", Strings.toString(MIN_REQUIRED_DIFF_BETWEEN_PARENT_AND_OBSERVER_ELIGIBILITY), " ahead compared to parent"));
        _childEligibilityTimestamp = childEligibilityTimestamp;
        _parentEligibilityTimestamp = parentEligibilityTimestamp;
        _observerEligibilityTimestamp = observerEligibilityTimestamp;

        _parentEmergencyWithdrawalAllowanceByChild = 0;
        _lastEmergencyWithrawalByChild_timestamp = 0;
        _lastEmergencyWithrawalByParent_timestamp = 0;

        require(emergencyWithdrawal_globalLimit > 1,
                "emergencyWithdrawal_globalLimit must be greater than 1");
        _emergencyWithdrawal_globalLimit = emergencyWithdrawal_globalLimit;
    }

    receive() external payable {}
    fallback() external payable {}
    
    /**
     * @dev Observer(s) are allowed to update childEmergencyWithdrawalLimit
     * @param amount: to set as the childEmergencyWithdrawalLimit
     */
    function updateChildEmergencyWithdrawalLimit(uint256 amount) public {
        require(msg.sender == _observer1 || msg.sender == _observer2, "Only observer(s) are allowed to update childEmergencyWithdrawalLimit");
        require(amount <= _emergencyWithdrawal_globalLimit, "Amount must be less than or equal to the emergencyWithdrawal_globalLimit");
        _childOrParentEmergencyWithdrawalAllowanceByObservers[msg.sender] = amount;
    }


    /**
     * @dev Child is allowed to update parentEmergencyWithdrawalLimit
     * @param amount: to set as the parentEmergencyWithdrawalLimit
     */
    function updateParentEmergencyWithdrawalLimit(uint256 amount) public {
        require(msg.sender == _child, "Only child is allowed to update parentEmergencyWithdrawalLimit");
        require(amount <= _emergencyWithdrawal_globalLimit, "Amount must be less than or equal to the emergencyWithdrawal_globalLimit");
        _parentEmergencyWithdrawalAllowanceByChild = amount;
    }

    /**
     * @dev Emergency-fund withdrawal (by child/parent -- upto what is allowed per custom limits)
     * @param amount: MAXIMUM (in case lower balance) amount to withdraw
     */
    function makeEmergencyWithdrawal(uint256 amount) public {
        require(amount > 0, "Amount must be greater than or equal to 0");
        require(address(this).balance > 0, "No amount left to withdraw");

        uint256 transferrableAmount = amount;
        if (address(this).balance < amount) {
            transferrableAmount = address(this).balance;
        }

        uint256 maxAllowanceByObservers = _childOrParentEmergencyWithdrawalAllowanceByObservers[_observer1];
        if (maxAllowanceByObservers < _childOrParentEmergencyWithdrawalAllowanceByObservers[_observer2]) {
            maxAllowanceByObservers = _childOrParentEmergencyWithdrawalAllowanceByObservers[_observer2];
        }

        if (msg.sender == _child) {
            require(transferrableAmount <= maxAllowanceByObservers,
                    string.concat("Max emergency-withdrawal limit for child = ", Strings.toString(maxAllowanceByObservers)));
            require(block.timestamp > _lastEmergencyWithrawalByChild_timestamp + MIN_REQUIRED_TIME_LAPSE_BEFORE_EMERGENCY_WITHDRAWAL,
                    string.concat("Child must wait atleast ", Strings.toString(MIN_REQUIRED_TIME_LAPSE_BEFORE_EMERGENCY_WITHDRAWAL), " seconds till next emergency withdrawal can be made"));

            _lastEmergencyWithrawalByChild_timestamp = block.timestamp;
        } else if (msg.sender == _parent1 || msg.sender == _parent2) {
            uint256 maxAllowanceForParents = maxAllowanceByObservers;
            if (maxAllowanceForParents < _parentEmergencyWithdrawalAllowanceByChild) {
                maxAllowanceForParents = _parentEmergencyWithdrawalAllowanceByChild;
            }

            require(transferrableAmount <= maxAllowanceForParents,
                    string.concat("Max emergency-withdrawal limit for parents = ", Strings.toString((maxAllowanceForParents))));
            require(block.timestamp > _lastEmergencyWithrawalByParent_timestamp + MIN_REQUIRED_TIME_LAPSE_BEFORE_EMERGENCY_WITHDRAWAL,
                    string.concat("Parent(s) must wait atleast ", Strings.toString(MIN_REQUIRED_TIME_LAPSE_BEFORE_EMERGENCY_WITHDRAWAL), " seconds till next emergency withdrawal can be made"));
                    
            _lastEmergencyWithrawalByParent_timestamp = block.timestamp;
        } else {
            require(false, "Emergency withdrawal can only be made by parents and child");
        }

        
        (bool success, ) = msg.sender.call{value: transferrableAmount}("");
        require(success, "Withdrawal failed");
    }


    /**
     * @dev Fund withdrawal (by child/parent/observer -- if eligible)
     * @param amount: MAXIMUM (in case lower balance) amount to withdraw
     */
    function withdraw(uint256 amount) public {
        require(amount > 0, "Amount must be greater than or equal to 0");
        require(address(this).balance > 0, "No amount left to withdraw");

        uint256 transferrableAmount = amount;
        if (address(this).balance < transferrableAmount) {
            transferrableAmount = address(this).balance;
        }

        if (msg.sender == _child) {
            require(block.timestamp > _childEligibilityTimestamp,
                    string.concat("Child must wait till timestamp", Strings.toString(_childEligibilityTimestamp), " to make normal withdrawal(s)"));
        } else if (msg.sender == _parent1 || msg.sender == _parent2) {
            require(block.timestamp > _parentEligibilityTimestamp,
                    string.concat("Parent(s) must wait till timestamp", Strings.toString(_parentEligibilityTimestamp), " to make normal withdrawal(s)"));
        } else if (msg.sender == _observer1 || msg.sender == _observer2) {
            require(block.timestamp > _observerEligibilityTimestamp,
                    string.concat("Observer(s) must wait till timestamp", Strings.toString(_observerEligibilityTimestamp), " to make normal withdrawal(s)"));
        } else {
            require(false, "Only child, parent(s) & observer(s) are allowed to make withdrawals");
        }
        
        (bool success, ) = msg.sender.call{value: transferrableAmount}("");
        require(success, "Withdrawal failed");
    }

    
    /**
     * @dev Returns the address(es) of all stakeholders involved 
     */
    function getStakeholders()  public view returns (string memory) {
        return string.concat("Child", Strings.toHexString(_child), "  \n",
                            "Parent-1", Strings.toHexString(_parent1), "  \n",
                            "Parent-2", Strings.toHexString(_parent2), "  \n",
                            "Observer-1", Strings.toHexString(_observer1), "  \n",
                            "Observer-2", Strings.toHexString(_observer2));
    }

    
    /**
     * @dev Returns the normal-withdrawal eligibilityTimestamps for all stakeholders
     */
    function getEligibilityTimestamps()  public view returns (string memory) {
        return string.concat("Child", Strings.toString(_childEligibilityTimestamp), "  \n",
                            "Parent(s)", Strings.toString(_parentEligibilityTimestamp), "  \n",
                            "Observer(s)", Strings.toString(_observerEligibilityTimestamp));
    }


    /**
     * @dev Returns the global-emergency-withdrawal-limit (the upperLimit for all other emergency-withdrawal limits)
     */
    function getGlobalEmergencyWithdrawalLimit()  public view returns (uint256) {
        return _emergencyWithdrawal_globalLimit;
    }


    /**
     * @dev Returns the latest childEmergencyWithdrawalLimit
     */
    function getChildEmergencyWithdrawalLimit()  public view returns (uint256) {
        uint256 maxAllowanceByObservers = _childOrParentEmergencyWithdrawalAllowanceByObservers[_observer1];
        if (maxAllowanceByObservers < _childOrParentEmergencyWithdrawalAllowanceByObservers[_observer2]) {
            maxAllowanceByObservers = _childOrParentEmergencyWithdrawalAllowanceByObservers[_observer2];
        }

        return maxAllowanceByObservers;
    }



    /**
     * @dev Returns the latest parentEmergencyWithdrawalLimit
     */
    function getParentEmergencyWithdrawalLimit()  public view returns (uint256) {
        uint256 maxAllowanceForParents = getChildEmergencyWithdrawalLimit();
        if (maxAllowanceForParents < _parentEmergencyWithdrawalAllowanceByChild) {
            maxAllowanceForParents = _parentEmergencyWithdrawalAllowanceByChild;
        }

        return maxAllowanceForParents;
    }
}

