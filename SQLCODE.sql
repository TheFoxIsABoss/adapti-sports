-- 1. Очистка и создание базы
DROP DATABASE IF EXISTS adaptive_sport_no_city_full;
CREATE DATABASE adaptive_sport_no_city_full;
USE adaptive_sport_no_city_full;


-- 2. Таблицы
CREATE TABLE sports (
  id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  category VARCHAR(50) NULL,
  adaptive BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE participants (
  age INT NOT NULL,        -- возраст/год рождения (как в вашем документе)
  sport_id INT NOT NULL,     -- ссылка на sports (0 = общая статистика без разбивки по спорту)
  gender ENUM('F','M') NOT NULL,
  count INT NOT NULL,
  PRIMARY KEY (age, sport_id, gender),
  FOREIGN KEY (sport_id) REFERENCES sports(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 3. Вставка видов спорта (0 = общий агрегат)
INSERT INTO sports (id, name, category, adaptive) VALUES
  (0, 'Все виды', 'Общее', FALSE),
  (1, 'Волейбол сидя', 'Волейбол', TRUE),
  (2, 'Легкая атлетика', 'Легкая атлетика', TRUE),
  (3, 'Баскетбол на колясках', 'Баскетбол', TRUE),
  (4, 'Стрельба пулевая', 'Стрельба', TRUE),
  (5, 'Плавание', 'Плавание', TRUE);


-- 4. Вставка данных
-- Пример: общая статистика по годам (girls = F, boys = M) из index_extracted.txt
-- Приведены числовые значения (из вашего документа):
-- 2005: Girls 0, Boys 1
-- 2006: Girls 0, Boys 0
-- 2007: Girls 0, Boys 1
-- 2008: Girls 1, Boys 4
-- 2009: Girls 3, Boys 3
-- 2010: Girls 4, Boys 2
-- 2011: Girls 2, Boys 3
-- 2012: Girls 1, Boys 2
-- 2013: Girls 3, Boys 4
-- 2014: Girls 2, Boys 5
-- 2015: Girls 1, Boys 2
-- 2016: Girls 1, Boys 3
-- 2017: Girls 4, Boys 6
-- 2018: Girls 2, Boys 6
-- 2019: Girls 2, Boys 3
-- 2020: Girls 2, Boys 4
-- 2021: Girls 1, Boys 2
-- 2022: Girls 0, Boys 0
-- 2023: Girls 0, Boys 0
-- 2024: Girls 0, Boys 1
-- 2025: Girls 0, Boys 0
-- 2026: Girls 1, Boys 0


-- Вставка (агрегат по всем видам спорта, sport_id = 0)
INSERT INTO participants (age, sport_id, gender, count) VALUES
  (2005, 0, 'F', 0), (2005, 0, 'M', 1),
  (2006, 0, 'F', 0), (2006, 0, 'M', 0),
  (2007, 0, 'F', 0), (2007, 0, 'M', 1),
  (2008, 0, 'F', 1), (2008, 0, 'M', 4),
  (2009, 0, 'F', 3), (2009, 0, 'M', 3),
  (2010, 0, 'F', 4), (2010, 0, 'M', 2),
  (2011, 0, 'F', 2), (2011, 0, 'M', 3),
  (2012, 0, 'F', 1), (2012, 0, 'M', 2),
  (2013, 0, 'F', 3), (2013, 0, 'M', 4),
  (2014, 0, 'F', 2), (2014, 0, 'M', 5),
  (2015, 0, 'F', 1), (2015, 0, 'M', 2),
  (2016, 0, 'F', 1), (2016, 0, 'M', 3),
  (2017, 0, 'F', 4), (2017, 0, 'M', 6),
  (2018, 0, 'F', 2), (2018, 0, 'M', 6),
  (2019, 0, 'F', 2), (2019, 0, 'M', 3),
  (2020, 0, 'F', 2), (2020, 0, 'M', 4),
  (2021, 0, 'F', 1), (2021, 0, 'M', 2),
  (2022, 0, 'F', 0), (2022, 0, 'M', 0),
  (2023, 0, 'F', 0), (2023, 0, 'M', 0),
  (2024, 0, 'F', 0), (2024, 0, 'M', 1),
  (2025, 0, 'F', 0), (2025, 0, 'M', 0),
  (2026, 0, 'F', 1), (2026, 0, 'M', 0);


-- Пример: данные по видам спорта (демо/псевдо-данные)
-- Волейбол сидя (id=1)
INSERT INTO participants (age, sport_id, gender, count) VALUES
  (2007, 1, 'F', 2), (2007, 1, 'M', 5),
  (2008, 1, 'F', 1), (2008, 1, 'M', 3);


-- Легкая атлетика (id=2)
INSERT INTO participants (age, sport_id, gender, count) VALUES
  (2008, 2, 'F', 1), (2008, 2, 'M', 4),
  (2009, 2, 'F', 3), (2009, 2, 'M', 3);


-- Баскетбол на колясках (id=3)
INSERT INTO participants (age, sport_id, gender, count) VALUES
  (2007, 3, 'F', 2), (2007, 3, 'M', 5),
  (2008, 3, 'F', 1), (2008, 3, 'M', 3);


-- Стрельба пулевая (id=4)
INSERT INTO participants (age, sport_id, gender, count) VALUES
  (2009, 4, 'F', 2), (2009, 4, 'M', 2);


-- Плавание (id=5)
INSERT INTO participants (age, sport_id, gender, count) VALUES
  (2010, 5, 'F', 4), (2010, 5, 'M', 2);


-- 5. Примеры запросов


-- 5.1 Общая статистика по возрасту и спорту с разбивкой по полу
SELECT
  p.age,
  s.name AS sport,
  p.gender,
  SUM(p.count) AS total
FROM participants p
JOIN sports s ON p.sport_id = s.id
GROUP BY p.age, p.sport_id, p.gender
ORDER BY p.age, sport, p.gender;


-- 5.2 Итоги по возрасту без разбивки по спорту (итоги по полу)
SELECT
  age,
  SUM(CASE WHEN gender = 'F' THEN count ELSE 0 END) AS females,
  SUM(CASE WHEN gender = 'M' THEN count ELSE 0 END) AS males,
  SUM(count) AS total
FROM participants
GROUP BY age
ORDER BY age;


-- 5.3 Итоги по возрасту и спорту для конкретного возраста (например, 2008)
SELECT
  s.name AS sport,
  SUM(p.count) AS total
FROM participants p
JOIN sports s ON p.sport_id = s.id
WHERE p.age = 2008
GROUP BY p.sport_id
ORDER BY sport;


-- 5.4 Итоги по спорту (одна строка на спорт)
SELECT
  s.name AS sport,
  SUM(p.count) AS total
FROM participants p
JOIN sports s ON p.sport_id = s.id
GROUP BY p.sport_id
ORDER BY sport;