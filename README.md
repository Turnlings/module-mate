# Grade Tracker (WIP)

A replacement for my scattering of spreadsheets I use to keep track of my university grades and time spent on tasks.

## Requirements

- Ruby 3.3.3
- Rails 7.1.5.1

## Setup

Clone and install dependencies:
```bash
git clone https://github.com/Turnlings/grade-tracker.git
cd grade-tracker
bundle install
```

Create a .env file:
```bash
touch .env
```

Add your devise secret key
```
DEVISE_SECRET_KEY=your_random_key_here
```

Set up the database:
```bash
rails db:create
rails db:migrate
```

Start the server:
```bash
rails s
```