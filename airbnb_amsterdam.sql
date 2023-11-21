CREATE DATABASE airbnb_amsterdam;
USE airbnb_amsterdam;

CREATE TABLE listings
 (
listing_id INT NOT NULL, 
name VARCHAR(300),
host_id INT,
host_name VARCHAR (50),
neighbourhood VARCHAR(50),
latitude DECIMAL(20),
longitude DECIMAL(20),
room_type VARCHAR(50),
price DECIMAL(10), 
minimum_nights INT,
number_of_reviews INT,
last_review VARCHAR (10), 
reviews_per_month DECIMAL (3),
calculated_host_listings_count INT, 
availability_365 INT
);

CREATE TABLE reviews_details
 (
listing_id INT NOT NULL, 
review_id INT NOT NULL,
review_date VARCHAR (10),
reviewer_id INT NOT NULL, 
reviewer_name VARCHAR(50)
);

CREATE TABLE listing_details
(
listing_id INT NOT NULL, 
name VARCHAR(300),
host_id INT,
host_name VARCHAR (50),
zipcode VARCHAR (20),
is_location_exact VARCHAR (2),
property_type VARCHAR(50),
room_type VARCHAR(50),
bathrooms DECIMAL (5), 
bedrooms DECIMAL (5),
beds INT, 
price VARCHAR (50),
cleaning_fees VARCHAR (50),
minimum_nights INT,
maximum_nights INT, 
number_of_reviews INT,
review_scores_rating INT,
calculated_host_listings_count INT, 
reviews_per_month DECIMAL (3)
);

SELECT DISTINCT host_id, host_name, listing_id FROM host_details;

CREATE TABLE host_details
(
host_id INT NOT NULL,
host_name VARCHAR (50),
listing_id INT NOT NULL
);

ALTER TABLE listings
ADD PRIMARY KEY (listing_id);

ALTER TABLE listing_details
ADD PRIMARY KEY (listing_id);

ALTER TABLE reviews_details
ADD PRIMARY KEY (review_id);

ALTER TABLE host_details
ADD PRIMARY KEY (host_id, listing_id);

ALTER TABLE reviews_details
ADD CONSTRAINT fk_review_listing_id 
FOREIGN KEY (listing_id)
REFERENCES listings (listing_id);

ALTER TABLE host_details
ADD CONSTRAINT fk_host_listings
FOREIGN KEY (listing_id)
REFERENCES listings(listing_id);

CREATE VIEW daniel_property_reviews
  AS
   SELECT
    listings.listing_id, 
	reviews_details.reviewer_name, 
    reviews_details.reviewer_id,
    listings.host_name, 
    listings.room_type,
    listings.name 
	  AS property_name
        FROM listings
          INNER JOIN 
             reviews_details 
                 ON 
                   listings.listing_id = reviews_details.listing_id
                         WHERE 
                         listings.host_name = 'Daniel';

SELECT 
  host_details.host_id, 
  host_details.host_name, 
  listings.listing_id,
  listings.name 
    AS
     property_name
        FROM 
          host_details
           CROSS JOIN
            listings
              ON
                host_details.listing_id = listings.listing_id
                  WHERE 
                    host_details.host_name 
                       LIKE 
                         'K%';

SELECT COUNT(listing_id) AS total_listings_per_host, host_name FROM listings
GROUP BY host_name
HAVING COUNT(listing_id) > 1
ORDER BY host_name ASC;

SELECT * FROM daniel_property_reviews
WHERE reviewer_name LIKE 't____';

SELECT reviewer_name, reviewer_id FROM daniel_property_reviews
WHERE reviewer_id NOT LIKE '1%'
ORDER BY reviewer_name ASC;

SELECT listing_id, name, host_name
  FROM listings
   WHERE listing_id IN 
     (SELECT listing_id FROM listing_details 
         WHERE bedrooms = '2');
         

USE airbnb_amsterdam;

CREATE VIEW 
 combined_table_view
  AS
   SELECT 
     listings.listing_id, 
     listing_details.price, 
     listing_details.cleaning_fees, 
     host_details.host_id, 
     reviews_details.review_date
       FROM 
         listings, listing_details, host_details, reviews_details;

SELECT * FROM combined_table_view;

CREATE VIEW 
 combined_table_view
  AS
   SELECT
    listings.listing_id,
    listing_details.room_type,
    host_details.host_name,
    reviews_details.review_date
       FROM 
         listings, listing_details, host_details, reviews_details
           WHERE 
               listings.listing_id = listing_details.listing_id
		     AND 
               listings.listing_id = host_details.listing_id
		     AND 
               listings.listing_id = reviews_details.listing_id
		     AND
               listings.listing_id 
                     NOT LIKE '2818'
		     AND 
			   host_details.host_name 
					NOT LIKE 'Daniel'
			              ORDER BY 
                             host_name ASC;







