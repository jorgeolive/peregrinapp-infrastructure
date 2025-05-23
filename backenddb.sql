CREATE SCHEMA IF NOT EXISTS peregrinapp;

CREATE TABLE peregrinapp.users (
    id SERIAL PRIMARY KEY,
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    nickname VARCHAR(50) UNIQUE NOT NULL,
    date_of_birth DATE,
    bio TEXT,
    is_activated BOOLEAN DEFAULT FALSE,
    password_hash VARCHAR(60),
    enable_dms BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE peregrinapp.activation_codes (
    id SERIAL PRIMARY KEY,
    phone_number VARCHAR(20) NOT NULL,
    user_id INTEGER NOT NULL,
    activation_code VARCHAR(6) NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (phone_number) REFERENCES peregrinapp.users(phone_number) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES peregrinapp.users(id)
);

CREATE TABLE IF NOT EXISTS peregrinapp.hostels (
    id INTEGER PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    address VARCHAR(255),
    phone VARCHAR(50),
    email VARCHAR(100),
    capacity INTEGER,
    price VARCHAR(50)
);

INSERT INTO peregrinapp.hostels (
    id,
    name,
    description,
    address,
    phone,
    email,
    capacity,
    price
) VALUES (
    1,
    'Albergue San Martín Pinario',
    'Historic albergue with beautiful architecture and peaceful atmosphere.',
    'Praza da Inmaculada, 3, 15704 Santiago de Compostela',
    '+34 981 560 282',
    'reservas@sanmartinpinario.com',
    100,
    '€15 per night'
);

CREATE TABLE IF NOT EXISTS peregrinapp.stages (
    id VARCHAR(50) PRIMARY KEY,
    length FLOAT NOT NULL,
    description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS peregrinapp.stageimages (
    id SERIAL PRIMARY KEY,
    stage_id VARCHAR(50) REFERENCES peregrinapp.stages(id) ON DELETE CASCADE,
    image_url VARCHAR(255) NOT NULL
);

-- Insert sample stages
INSERT INTO peregrinapp.stages (id, length, description) VALUES
('ES03a_01e', 25.5, 'Irún to San Sebastián - A beautiful coastal walk with stunning views of the Bay of Biscay.'),
('ES03a_01b', 20.3, 'San Sebastián to Zarautz - Rolling hills and charming Basque villages.'),
('ES03a_01d', 18.7, 'Zarautz to Deba - Coastal paths and rugged cliffs.'),
('ES03a_02a', 22.1, 'Deba to Markina-Xemein - A mix of coastal and inland scenery.'),
('ES03a_06a', 24.8, 'Markina-Xemein to Gernika - Historical sites and lush countryside.'),
('ES03a_14b', 19.5, 'Gernika to Bilbao - Urban and rural landscapes.'),
('ES03a_23b', 23.2, 'Bilbao to Portugalete - Industrial heritage and river views.'),
('ES03a_21a', 21.4, 'Portugalete to Castro Urdiales - Coastal paths and historic towns.'),
('ES03a_30a', 20.9, 'Castro Urdiales to Laredo - Beautiful beaches and coastal trails.'),
('ES03a_10a', 18.6, 'Laredo to Güemes - Rural landscapes and traditional villages.'),
('ES03a_12c', 19.8, 'Stage description for ES03a_12c'),
('ES03a_20a', 22.3, 'Stage description for ES03a_20a'),
('ES03a_17a', 21.7, 'Stage description for ES03a_17a'),
('ES03a_26a', 20.5, 'Stage description for ES03a_26a'),
('ES03a_11a', 23.1, 'Stage description for ES03a_11a'),
('ES03a_25a', 19.2, 'Stage description for ES03a_25a'),
('ES03a_14a', 24.3, 'Stage description for ES03a_14a'),
('ES03a_24a', 18.9, 'Stage description for ES03a_24a'),
('ES03a_12b', 22.6, 'Stage description for ES03a_12b'),
('ES03a_21b', 20.8, 'Stage description for ES03a_21b'),
('ES03a_31a', 19.4, 'Stage description for ES03a_31a'),
('ES03a_11c', 21.9, 'Stage description for ES03a_11c'),
('ES03a_15a', 23.5, 'Stage description for ES03a_15a'),
('ES03a_16a', 20.1, 'Stage description for ES03a_16a'),
('ES03a_19a', 22.8, 'Stage description for ES03a_19a'),
('ES03a_23a', 19.7, 'Stage description for ES03a_23a'),
('ES03a_12a', 21.2, 'Stage description for ES03a_12a'),
('ES03a_28a', 23.8, 'Stage description for ES03a_28a'),
('ES03a_11d', 20.4, 'Stage description for ES03a_11d'),
('ES03a_27a', 22.5, 'Stage description for ES03a_27a'),
('ES03a_22a', 19.1, 'Stage description for ES03a_22a'),
('ES03a_26b', 21.6, 'Stage description for ES03a_26b'),
('ES03a_29a', 23.4, 'Stage description for ES03a_29a'),
('ES03a_01c', 20.2, 'Stage description for ES03a_01c'),
('ES03a_03a', 22.4, 'Stage description for ES03a_03a'),
('ES03a_07a', 19.3, 'Stage description for ES03a_07a'),
('ES03a_31b', 21.8, 'Stage description for ES03a_31b'),
('ES03a_18b', 23.6, 'Stage description for ES03a_18b'),
('ES03a_13a', 20.6, 'Stage description for ES03a_13a'),
('ES03a_03b', 22.7, 'Stage description for ES03a_03b'),
('ES03a_05a', 19.9, 'Stage description for ES03a_05a'),
('ES03a_04b', 21.3, 'Stage description for ES03a_04b'),
('ES03a_18a', 23.7, 'Stage description for ES03a_18a'),
('ES03a_11b', 20.7, 'Stage description for ES03a_11b'),
('ES03a_04a', 22.2, 'Stage description for ES03a_04a'),
('ES03a_08a', 19.6, 'Stage description for ES03a_08a'),
('ES03a_09a', 21.5, 'Stage description for ES03a_09a');

-- Insert images for each stage
INSERT INTO peregrinapp.stageimages (stage_id, image_url) VALUES
('ES03a_01e', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_01e', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_01b', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_01b', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_01d', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_01d', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_02a', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_02a', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_06a', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_06a', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_14b', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_14b', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_23b', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_23b', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_21a', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_21a', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_30a', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_30a', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_10a', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_10a', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_12c', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_12c', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_20a', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_20a', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_17a', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_17a', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_26a', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_26a', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_11a', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_11a', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_25a', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_25a', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_14a', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_14a', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_24a', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_24a', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_12b', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_12b', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_21b', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_21b', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_31a', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_31a', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_11c', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_11c', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_15a', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_15a', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_16a', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_16a', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_19a', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_19a', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_23a', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_23a', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_12a', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_12a', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_28a', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_28a', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_11d', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_11d', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_27a', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_27a', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_22a', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_22a', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_26b', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_26b', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_29a', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_29a', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_01c', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_01c', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_03a', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_03a', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_07a', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_07a', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_31b', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_31b', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_18b', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_18b', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_13a', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_13a', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_03b', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_03b', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_05a', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_05a', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_04b', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_04b', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_18a', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_18a', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_11b', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_11b', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_04a', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_04a', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_08a', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_08a', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg'),
('ES03a_09a', 'http://10.0.2.2:3000/peregrinapp/images/image1.jpg'),
('ES03a_09a', 'http://10.0.2.2:3000/peregrinapp/images/image2.jpg');