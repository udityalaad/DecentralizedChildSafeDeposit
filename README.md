<!-- Reference:
https://github.com/othneildrew/Best-README-Template -->
<a name="readme-top"></a>


<!-- PROJECT LOGO -->
<br />
<div align="center">
  <h1><i>Decentralized Child Safe Deposit</i></h1>


  
  <img src="Read_Me_Content/top_label.jpg" alt="top_label.jpg">
  .

  <p align="center">
    An ethereum smart contract to facilitate a decentralized safe-deposit !
  </p>
</div>
 
<br>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#about-the-project">About The Project</a></li>
    <li><a href="#built-with">Built With</a></li>
    <li><a href="#getting-started">Getting Started</a></li>
    <li><a href="#license-or-author">License or Author</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

<br>

<!-- ABOUT THE PROJECT -->
## About The Project
  An ethereum smart contract to facilitate a decentralized safe-deposit with support for lock-in, delayed availability, emergency withdrawal, observer actions & enhanced security

  #### Rules of the system
  1. Parent(s) make periodic fund deposits
  2. Child can withdraw funds after a specified (future) eligibility timestamp
      - *Else* - Parent(s) can withdraw funds (atleast 1 year post child's eligibility)
      - *Else* - Observer(s) can withdraw funds (atleast 2 year post parents' eligibility)
  3. Emergency Withdrawals (with daily limits)
      - *Child* - Before eligibility, can withdraw upto the maximum daily limit (set by the observers)
      - *Parent(s)* - Before eligibility, can withdraw upto the maximum daily limit (set by child/observers)
      - *Observer(s)* - Not allowed

  <p align="right">(<a href="#readme-top">back to top</a>)</p>

## Built With
  &nbsp; &nbsp; &nbsp; &nbsp; <img src="Read_Me_Content/Tech/Solidity.png" alt="Solidity_Logo" width="85"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <img src="Read_Me_Content/Tech/nodejs.png" alt="NodeJS_Logo" width="75"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <img src="Read_Me_Content/Tech/Ethereum.png" alt="Ethereum_Logo" width="85"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <img src="Read_Me_Content/Tech/Remix.png" alt="Remix_Logo" width="85"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <img src="Read_Me_Content/Tech/js.JPG" alt="JavaScript_Logo" width="62">

  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <b><i> Solidity </i></b> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <b><i> NodeJS </i></b> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <b><i> Ethereum </i></b> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <b><i> Remix </i></b> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <b><i> JavaScript </i></b>

  <p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started
  #### Prerequisites
  * Solidity
  * Ethereum LightWeight node
  * NodeJS
  * Dependencies (Configured in each application)
  * IDE - Remix (Preferred)
  * Minimum - 8GB RAM, Intel i5 CPU (or Equivalent)

  #### Setup & Use
  * Zip the repo
  * Go to Remix IDE & import the zip into a new workspace
  * Go to contracts & compile the required contract
  * Go to deploy section
  * Test with Virtual Machine & test accounts in VM
  * Deploy to Ethereum mainnet and test
  * Invite others to interact with the deployed contract (directly/indirectly)

  <p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- LICENSE -->
## License or Author
  * Uditya Laad

  <p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact
  <b>Uditya Laad</b> &nbsp; [@linkedin.com/in/uditya-laad-222680148](https://www.linkedin.com/in/uditya-laad-222680148/)
  
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; [@github.com/udityalaad](https://github.com/udityalaad)
  
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; udityalaad123@gmail.com

  <b>Project Link</b> &nbsp; [https://github.com/udityalaad/DecentralizedChildSafeDeposit](https://github.com/udityalaad/TravelGenius)

  <p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments
  * [Open Source Stack, Openzeppelin](https://www.openzeppelin.com/open-source-stack)
  * [Remix Resources](https://remix-project.org/?lang=en)
  * [github.com/othneildrew/Best-README-Template/](https://github.com/othneildrew/Best-README-Template)
  <p align="right">(<a href="#readme-top">back to top</a>)</p>
