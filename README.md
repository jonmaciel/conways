# Conway's Game of Life - Backend

This is the backend for Conway's Game of Life, implemented in Ruby on Rails. The backend manages boards and their generations, providing an API for the [front-end interface](https://github.com/jonmaciel/conways-ui).

## Ruby version

- Ruby version: 3.3.4

## Table of Contents

- [Features](#features)
- [Technologies Used](#technologies-used)
- [Installation](#installation)
- [API Endpoints](#api-endpoints)
- [Testing](#testing)
- [Code quality](#code-quality)
- [CSV sample](#csv-sample)

## Features

- Create boards with initial states using CSV uploads.
- Manage generations of the board.
- Retrieve the next generation based on game rules.
- Keep track of attempts made on the board.

## Technologies Used

- **Ruby on Rails**: Server-side framework for building the API.
- **PostgreSQL**: The chosen database for the application.
- **RSpec**: For testing the application.
- **CSV**: For handling CSV uploads.

## Installation

1. Install the required gems:
```bash
bundle install 
```

2. create database
```bash
rails db:create
rails db:migrate
```

3. Start the server:
```bash
rails s
```

## API Endpoints

- **GET** `/boards`: Retrieve all boards.
- **GET** `/boards/:id`: Retrieve a specific board.
- **POST** `/boards`: Upload a CSV file to create a new board.
- **POST** `/boards/:id/next_generation`: Advance the board to the next generation.
- **GET** `/boards/:id/generations`: Retrieve all generations of a board.
- **GET** `/boards/:id/generations/:id`: Retrieve a specific generation of a board.


## Testing
```bash
bundle exec rspec
```
## Code quality

```bash
bundle exec rubocop
```

## CSV sample

```
1,0,1,0,0,1,0,1,0
0,1,0,1,0,0,1,0,1
0,0,1,0,1,0,0,1,0
1,0,1,0,0,0,1,0,0
0,1,0,1,1,0,1,0,1
1,0,0,0,1,1,0,0,1
0,0,1,0,1,0,1,1,0
1,0,0,1,0,0,1,0,1
0,1,0,0,1,0,1,0,0
```


