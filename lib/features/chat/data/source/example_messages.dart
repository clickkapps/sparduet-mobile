const exampleMessages = [
  {
    "id": 1,
    "message": "Lorem Ipsum is simply dummy. ",
    // "message": "Lorem Ipsum is simply ",
    "createdAt": "2023-12-19T09:41:04.000Z",
    "isSender": true,

    "parentMessage": {
      "id": 100,
      "isSender": true,
      "message": "Have a great"
    },

  },
  {
    "id": 2,
    "message": "Thanks for telling",
    "createdAt": "2023-12-19T12:10:04.000Z",
    "parentMessage": {
      "id": 100,
      "isSender": true,
      "message": "Have a great day with"
    },
    "isSender": false
  },
  {
    "id": 2,
    "message": "Thanks for telling",
    "createdAt": "2023-12-19T12:10:04.000Z",
    "isSender": false
  },
  {
    "id": 3,
    "message": "I've tried the app",
    "createdAt": "2023-12-19T12:10:04.000Z",
    "parentMessage": {
      "id": 100,
      "isSender": true,
      "message": "Have a great day with my amazing client all the way from NewYork"
    },
    "isSender": true
  },
  {
    "id": 4,
    "message": "Yeah, It's really good!",
    "createdAt": "2023-12-19T12:10:04.000Z",
    "isSender": true
  },
];