# MeetNow :calendar: :pushpin:
## Connect, Celebrate, and Explore: MeetNow brings your events to life on an interactive map!

https://github.com/AdrianSzlag/MeetNow/assets/92638498/7910bd4b-7d5b-468a-912b-95f0d1a6a8ef

MeetNow is an application designed to facilitate the organization of meetups and display them on an interactive map. Users can create their own events that fall under one of three categories: PARTY, SPORT, EVENT. The app aims to assist in organizing meetups as well as allowing users to join ongoing meetups.


## Presentation
Check out the [Figma Presentation](https://www.figma.com/proto/3OB6ywFOgmvtFh2O2L0jXB/Untitled?node-id=1%3A2&scaling=scale-down&page-id=0%3A1) for our Figma demo.


## Technologies Used
### Frontend
- **Framework**: React
- **Styling Library**: Tailwind CSS
- **Map Display**: Pidgeon Map API integrated with Mapbox API

### Backend
- **Framework**: Spring Boot
- **User Authentication**: JWT and Spring Security
- **ORM**: Hibernate and Spring Data JPA


### Database
- **Database**: PostgreSQL
- **Migration**: FlywayDB
- **Extension**: PostGIS for storing event coordinates

## Getting Started
### Prerequisites
- Docker
- Node.js
- Java SDK

### Installation
1. Clone the repo
```
git clone https://github.com/AdrianSzlag/MeetNow.git
```
2. Run Docker file
```
docker-compose up
```

### Running the App
Once the Docker containers are up, the application should be available at http://localhost:3000

## Usage
1. **Login/Registration**: Start by logging in or registering a new account.
2. **Event Creation**: Navigate to the 'Create Event' button to input details of the event you want to create.
3. **Map View**: Browse through the interactive map to discover ongoing or upcoming events.
4. **Join Event**: Click on any event marker to view details and join the event.
5. **Filter Events**: Use the filter options to display events based on categories like PARTY, SPORT, or EVENT.
6. **Add Memories**: Utilize the camera feature to capture and add images to ongoing events.

## Contributors
- [Szymon Salamon](https://github.com/SzymonSalamon): Team Leader, UI/UX Designer, Frontend Developer
- [Adrian Szlag](https://github.com/AdrianSzlag): Frontend Developer
- [Paweł Samuła](https://github.com/psamula): Backend Developer
- [Bartosz Słowik](https://github.com/Bartosz-Slowik): SQL Developer


## Features
- User-generated events
- Participate in events
- Create promotional posts for events
- Interactive map with event markers
- Multi-category event differentiation
- Add images to an event
- View posts and memories from past events
- Event filtering options
- Responsive design

## Database Schema
![image](https://github.com/AdrianSzlag/MeetNow/assets/92638498/8d99a658-ed9a-4237-b9a4-9c922e18f6f5)


## API Documentation
Backend functionality is documented with Swagger UI (http://localhost:8080/swagger-ui/)

## About The Project
MeetNow is a platform for organizing and discovering local meetups and events, designed to help you explore your community and meet new friends. This application was initially conceived as a hackathon project and has since been under active development. For more background, you can check out the original: [2023 Kościuszkon submission](https://github.com/Bartosz-Slowik/Tuptup-Hackaton).

### Happy Meeting!
