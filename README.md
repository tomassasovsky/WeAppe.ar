<div id="top"></div>
<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]
<!--[![Forks][forks-shield]][forks-url]-->



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/github_username/repo_name">
    <img src="https://media-exp1.licdn.com/dms/image/C4E0BAQF8LB_Jg4aj8A/company-logo_200_200/0/1650577795934?e=1662595200&v=beta&t=VJvmARSVtQG58kKrfExyJkhwBhugG_Wmjncr0dI8-Yo" alt="Logo" width="80" height="80">
  </a>

<h3 align="center">WeAppe.ar</h3>

  <p align="center">
    Open source time logger backend made in Dart
    <br />
    <a href="https://github.com/github_username/repo_name"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/github_username/repo_name">View Demo</a>
    ·
    <a href="https://github.com/tomassasovsky/WeAppe.ar/issues">Report Bug</a>
    ·
    <a href="https://github.com/tomassasovsky/WeAppe.ar/issues">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#setting-up-the-project">Setting up the project</a></li>
        <li><a href="#deploying">Deploying</a></li>
      </ul>
    </li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

<!-- [![Product Name Screen Shot][product-screenshot]](https://example.com)-->

There are many time trackers in the market that can let you log your hours to projects, but the main problematic behind them is that after the project manager take you out of the project you can't view or see your time logs anymore, so therefore you can't demonstrate the hours you worked.

<p align="right">(<a href="#top">back to top</a>)</p>



### Built With

* [Dart](https://dart.dev/)
* [Alfred Package](https://pub.dev/packages/alfred)

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

### Prerequisites

You need to have installed at least the version 2.17.0 of Dart.
* [Dart SDK installation guide](https://dart.dev/get-dart)

### Setting up the project

1. Clone the repo
   ```sh
   git clone https://github.com/tomassasovsky/WeAppe.ar.git
   ```
3. Install Pub packages
   ```sh
   flutter pub get
   ```
4. Configure the `.env` file
   ```js
   MONGO_CONNECTION=your_mongo_connection_string
   JWT_REFRESH_TOKEN_SIGNATURE=your_jwt_refresh_token_signature
   JWT_ACCESS_TOKEN_SIGNATURE=your_jwt_access_token_signature
   IMGUR_CLIENT_ID=your_client_id_for_IMGUR
   INVITE_EMAIL_ACCOUNT=your_email_address_for_invite_email@mail.com
   INVITE_EMAIL_PASSWORD=email_address_password
   INVITE_EMAIL_HOST=the_host_of_your_email_address (e.g. smtp.gmail.com)
   INVITE_EMAIL_PORT=the_port_of_your_email_address (e.g. 465)
   INVITE_EMAIL_USER_NAME=The Name You Want To Use For The Email Address (e.g. Alfred Server)
   HOST=where_you_want_to_host_the_server (e.g. http://localhost:8080)
   ```


### Deploying
This is our recomendation to deploy this backend, know that there are problably some other ways to make your project go live.
1. Create a new project in Google Cloud Run. Here is the [documentation](https://cloud.google.com/appengine/docs/standard/nodejs/building-app/creating-project) on how to.

<div align="center">
<img src="https://i.imgur.com/xgrsBJf.png" alt="Logo">
</div>

2. Install the gcloud CLI https://cloud.google.com/sdk/docs/install.

3. Go to the [Google Cloud Console API](https://console.cloud.google.com/projectselector2/home/dashboard) and create a project. Note the project id, something like weappear-test.

4. Run gcloud auth login to authenticate with google cloud as the [documentation](https://cloud.google.com/sdk/gcloud/reference/auth/login) says.

5. Run the next the command to deploy it:
    ```sh
   gcloud beta run deploy weappearbackend --source . --allow-unauthenticated --project=[PROJECT_ID, in this case, weappear-test]
   ```

6. To set-up the enviroment variables enter to your running Google Cloud Run project and click on "Edit and deploy a new revision".
<div align="center">
<img src="https://i.imgur.com/JAo0F8l.png" alt="Logo">
</div>

7. Go to your variables and secrets tab, and fill out everything from the .env file.
<div align="center">
<img src="https://i.imgur.com/sQM7SaS.png" alt="Logo">
</div>
<p align="right">(<a href="#top">back to top</a>)</p>

## Endpoints and Usage
We have an active [Postman Workspace](https://documenter.getpostman.com/view/14403011/UVJfhuvf) with all the endpoints and responses updated where you can check the behavior of the backend to implement it.
<p align="right">(<a href="#top">back to top</a>)</p>


<!-- ROADMAP -->
## Roadmap

#### Testing

- [ ] 100% test coverage

### Features

- [X] User Login
- [X] Register with account activation via email.
- [X] Create entities to clock in/out to
- [X] Join entities to clock in/out to
- [X] Clock in/out to entities
- [X] Picture upload to Imgur
- [ ] Task creation/asignation for clock ins/outs
- [ ] Clock in/out pagination
- [ ] 2 Factor Authentication

See the [open issues](https://github.com/tomassasovsky/WeAppe.ar/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Tomás Sasovsky - [@tomaSasovsky](https://twitter.com/tomaSasovsky) - tomas@weappe.ar

Nazareno Cavazzon - [@NCavazzon](https://twitter.com/NCavazzon) - cavazzonnazareno@gmail.com

Jorge Rincon Arias - [@JorgeR5](https://twitter.com/JorgeR5) - rinconj.jra@gmail.com

Project Link: [https://github.com/tomassasovsky/WeAppe.ar](https://github.com/tomassasovsky/WeAppe.ar)

<p align="right">(<a href="#top">back to top</a>)</p>




<p align="right">(<a href="#top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/tomassasovsky/WeAppe.ar.svg?style=for-the-badge
[contributors-url]: https://github.com/tomassasovsky/WeAppe.ar/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/tomassasovsky/WeAppe.ar/.svg?style=for-the-badge
[forks-url]: https://github.com/tomassasovsky/WeAppe.ar/network/members
[stars-shield]: https://img.shields.io/github/stars/tomassasovsky/WeAppe.ar.svg?style=for-the-badge
[stars-url]: https://github.com/tomassasovsky/WeAppe.ar/stargazers
[issues-shield]: https://img.shields.io/github/issues/tomassasovsky/WeAppe.ar.svg?style=for-the-badge
[issues-url]: https://github.com/gtomassasovsky/WeAppe.ar/issues
[license-shield]: https://img.shields.io/github/license/tomassasovsky/WeAppe.ar.svg?style=for-the-badge
[license-url]: https://github.com/tomassasovsky/WeAppe.ar/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/company/weappear
[product-screenshot]: images/screenshot.png