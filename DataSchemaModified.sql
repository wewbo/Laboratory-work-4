-- Видалення існуючих таблиць з каскадним видаленням обмежень
DROP TABLE IF EXISTS noise_level CASCADE;
DROP TABLE IF EXISTS current_data CASCADE;
DROP TABLE IF EXISTS noise_environment CASCADE;
DROP TABLE IF EXISTS recommendations CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- Створення таблиці noise_environment
CREATE TABLE NoiseEnvironment (
    id SERIAL PRIMARY KEY, -- Первинний ключ
    description VARCHAR(255) NOT NULL -- Опис шумового середовища
);

-- Створення таблиці current_data
CREATE TABLE current_data (
    id SERIAL PRIMARY KEY, -- Первинний ключ
    timestamp TIMESTAMP NOT NULL, -- Дата та час збору даних
    noise_level_value FLOAT NOT NULL, -- Числове значення рівня шуму
    noise_environment_id INTEGER, -- Зовнішній ключ на NoiseEnvironment
    recommendations_id INTEGER, -- Зовнішній ключ на Recommendations
    CONSTRAINT fk_noise_environment FOREIGN KEY (noise_environment_id)
    REFERENCES noise_environment (id) ON DELETE CASCADE,
    CONSTRAINT fk_recommendations FOREIGN KEY (recommendations_id)
    REFERENCES recommendations (id) ON DELETE SET NULL
);

-- Створення таблиці noise_level
CREATE TABLE noise_level (
    id SERIAL PRIMARY KEY, -- Первинний ключ
    value FLOAT NOT NULL, -- Числове значення рівня шуму в децибелах
    current_data_id INTEGER, -- Зовнішній ключ на CurrentData
    CONSTRAINT fk_current_data FOREIGN KEY (current_data_id)
    REFERENCES current_data (id) ON DELETE CASCADE
);

-- Створення таблиці recommendations
CREATE TABLE recommendations (
    id SERIAL PRIMARY KEY, -- Первинний ключ
    text VARCHAR(255) NOT NULL, -- Текст рекомендації
    type VARCHAR(50) NOT NULL, -- Тип рекомендації (для здоров'я тощо)
    user_id INTEGER, -- Зовнішній ключ на Users
    CONSTRAINT fk_user FOREIGN KEY (user_id)
    REFERENCES users (id) ON DELETE SET NULL,
    CONSTRAINT chk_type_format CHECK
    (type ~ '^[А-Яа-яІіЇїЄєҐґa-zA-Z ]+$') -- Обмеження на лише літери та пробіли
);

-- Створення таблиці users
CREATE TABLE users (
    id SERIAL PRIMARY KEY, -- Первинний ключ
    name VARCHAR(100) NOT NULL, -- Ім'я користувача
    email VARCHAR(100) NOT NULL,
    CONSTRAINT chk_email_format CHECK
    (email ~ '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
    -- Формат електронної пошти
);
