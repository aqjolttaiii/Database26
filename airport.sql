CREATE TABLE Airline_info (
    airline_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    airline_code VARCHAR(30) NOT NULL,
    airline_name VARCHAR(50) NOT NULL,
    airline_country VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    info VARCHAR(50)
);
 
CREATE TABLE Airport (
    airport_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    airport_name VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    state VARCHAR(50),
    city VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
 
CREATE TABLE Passengers (
    passenger_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(50) NOT NULL,
    country_of_citizenship VARCHAR(50) NOT NULL,
    country_of_residence VARCHAR(50) NOT NULL,
    passport_number VARCHAR(20) NOT NULL UNIQUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
 
CREATE TABLE Flights (
    flight_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sch_departure_time TIMESTAMP NOT NULL,
    sch_arrival_time TIMESTAMP NOT NULL,
    departing_airport_id INT NOT NULL,
    arriving_airport_id INT NOT NULL,
    departing_gate VARCHAR(50) NOT NULL,
    arriving_gate VARCHAR(50) NOT NULL,
    airline_id INT NOT NULL,
    act_departure_time TIMESTAMP,
    act_arrival_time TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
 
CREATE TABLE Booking (
    booking_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    flight_id INT NOT NULL,
    passenger_id INT NOT NULL,
    booking_platform VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL,
    price DECIMAL(7,2) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
 
CREATE TABLE Booking_flight (
    booking_flight_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    booking_id INT NOT NULL,
    flight_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
 
CREATE TABLE Boarding_pass (
    boarding_pass_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    booking_id INT NOT NULL,
    seat VARCHAR(50) NOT NULL,
    boarding_time TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
 
CREATE TABLE Baggage (
    baggage_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    weight_in_kg DECIMAL(4,2) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    booking_id INT NOT NULL
);
 
CREATE TABLE Baggage_check (
    baggage_check_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    check_result VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    booking_id INT NOT NULL,
    passenger_id INT NOT NULL
);
 
CREATE TABLE Security_check (
    security_check_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    check_result VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    passenger_id INT NOT NULL
);
ALTER TABLE Airline_info RENAME TO Airline;
ALTER TABLE Booking RENAME COLUMN price TO ticket_price;
ALTER TABLE Flights ALTER COLUMN departing_gate TYPE TEXT;
ALTER TABLE Airline DROP COLUMN info;
-- Passengers with Security_check, Booking, Baggage_check (by passenger_id)
ALTER TABLE Security_check
    ADD CONSTRAINT fk_security_passenger
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id);
 
ALTER TABLE Booking
    ADD CONSTRAINT fk_booking_passenger
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id);
 
ALTER TABLE Baggage_check
    ADD CONSTRAINT fk_baggagecheck_passenger
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id);
 
-- Booking with Baggage_check, Baggage, Boarding_pass, Booking_flight (by booking_id)
ALTER TABLE Baggage_check
    ADD CONSTRAINT fk_baggagecheck_booking
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id);
 
ALTER TABLE Baggage
    ADD CONSTRAINT fk_baggage_booking
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id);
 
ALTER TABLE Boarding_pass
    ADD CONSTRAINT fk_boardingpass_booking
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id);
 
ALTER TABLE Booking_flight
    ADD CONSTRAINT fk_bookingflight_booking
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id);
 
-- Flights with Booking_flight (by flight_id)
ALTER TABLE Booking_flight
    ADD CONSTRAINT fk_bookingflight_flight
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id);
 
-- Airport with Flights (by departing_airport_id and arriving_airport_id)
ALTER TABLE Flights
    ADD CONSTRAINT fk_flights_departure_airport
    FOREIGN KEY (departing_airport_id) REFERENCES Airport(airport_id);
 
ALTER TABLE Flights
    ADD CONSTRAINT fk_flights_arrival_airport
    FOREIGN KEY (arriving_airport_id) REFERENCES Airport(airport_id);
 
-- Airline with Flights (by airline_id)
ALTER TABLE Flights
    ADD CONSTRAINT fk_flights_airline
    FOREIGN KEY (airline_id) REFERENCES Airline(airline_id);
