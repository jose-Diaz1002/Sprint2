CREATE DATABASE youtube;
-- DROP DATABASE youtube;
USE youtube;
CREATE TABLE users(
	id_user INTEGER PRIMARY KEY AUTO_INCREMENT,
    password VARCHAR(20) NOT NULL,
    user_name VARCHAR(45) NOT NULL UNIQUE,
    birthdate DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Non-binary', 'Prefer not to say')  NOT NULL,
    country VARCHAR(20) NOT NULL,
    postal_code VARCHAR(20)    
);

CREATE TABLE post_videos(
	id_post_video INTEGER PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50) NOT NULL,
    size DECIMAL NOT NULL,
    file_name VARCHAR(50) NOT NULL,
    how_long_video TIME NOT NULL,
    thumbnail VARCHAR(200) NOT NULL,
    number_views INTEGER,
	number_likes INTEGER,
	number_dislikes INTEGER,
    visibility ENUM('public', 'hidden', 'private') NOT NULL DEFAULT 'private'
);
ALTER TABLE post_videos ADD COLUMN id_user INTEGER NOT NULL;
ALTER TABLE post_videos ADD FOREIGN KEY (id_user) REFERENCES users(id_user);   
ALTER TABLE post_videos ADD COLUMN date_time DATETIME NOT NULL;
ALTER TABLE post_videos ADD COLUMN  description TEXT;

CREATE TABLE tags(
	id_tag INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);


CREATE TABLE video_tags (
    id_post_video INT,
    id_tag INT,
    PRIMARY KEY (id_post_video, id_tag),
    FOREIGN KEY (id_post_video) REFERENCES post_videos(id_post_video),
    FOREIGN KEY (id_tag) REFERENCES tags(id_tag)
);

CREATE TABLE channel(
	id_channel INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    description TEXT,
    creation_date DATETIME NOT NULL, 
    id_user INTEGER NOT NULL,
    FOREIGN KEY (id_user) REFERENCES users (id_user)
);

CREATE TABLE video_reaction (
    id_user INT,
    id_post_video INT,
	like_dislike ENUM('like', 'dislike'),
    date_reaction DATETIME,
    PRIMARY KEY (id_user, id_post_video),
    FOREIGN KEY (id_user) REFERENCES users(id_user),
    FOREIGN KEY (id_post_video) REFERENCES post_videos(id_post_video)
);
CREATE TABLE playlist (
    id_playlist INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    creation_date DATETIME,
    state ENUM('publica', 'privada'),
    id_user INT,
    FOREIGN KEY (id_user) REFERENCES users(id_user)
);

CREATE TABLE playlist_video (
    id_playlist INT,
    id_post_video INT,
    PRIMARY KEY (id_playlist, id_post_video),
    FOREIGN KEY (id_playlist) REFERENCES playlist(id_playlist),
    FOREIGN KEY (id_post_video) REFERENCES post_videos(id_post_video)
);

CREATE TABLE comments (
    id_comment INT PRIMARY KEY AUTO_INCREMENT,
    text_comment TEXT,
    date_comment DATETIME,
    id_user INT,
    id_post_video INT,
    FOREIGN KEY (id_user) REFERENCES users (id_user),
    FOREIGN KEY (id_post_video) REFERENCES post_videos (id_post_video)
);

CREATE TABLE reation_comments (
    id_user INT,
    id_comment INT,
    like_dislike ENUM('like', 'dislike'),
    data_reation DATETIME,
    PRIMARY KEY (id_user, id_comment),
    FOREIGN KEY (id_user) REFERENCES users(id_user),
    FOREIGN KEY (id_comment) REFERENCES comments(id_comment)
);

CREATE TABLE subscription (
    id_user INT,
    id_user_subscribed INT,
    date_subscription DATETIME,
    PRIMARY KEY (id_user, id_user_subscribed),
    FOREIGN KEY (id_user) REFERENCES users(id_user),
    FOREIGN KEY (id_user_subscribed) REFERENCES users (id_user)
);

-- Usuarios
INSERT INTO users (password, user_name, birthdate, gender, country, postal_code) VALUES
('pass123', 'juan_gamer', '1995-06-15', 'Male', 'Spain', '28001'),
('pass456', 'laura_music', '1998-11-22', 'Female', 'Spain', '08001'),
('pass789', 'carlos_vlogs', '2000-03-05', 'Male', 'Mexico', '01000');

-- Canales
INSERT INTO channel (name, description, creation_date, id_user) VALUES
('Gaming Zone', 'Canal de juegos y streaming', NOW(), 1),
('Laura Canta', 'Canal de música y covers', NOW(), 2),
('Vida de Carlos', 'Vlogs diarios y aventuras', NOW(), 3);

-- Videos
INSERT INTO post_videos (title, size, file_name, how_long_video, thumbnail, number_views, number_likes, number_dislikes, visibility, id_user, date_time, description) VALUES
('Gameplay Fortnite', 250.5, 'fortnite.mp4', '00:20:00', 'thumb1.jpg', 5000, 300, 15, 'public', 1, NOW(), 'Partida épica de Fortnite'),
('Cover Despacito', 180.2, 'despacito.mp4', '00:03:45', 'thumb2.jpg', 8000, 500, 10, 'public', 2, NOW(), 'Mi versión de Despacito'),
('Viaje a Cancún', 320.0, 'cancun_vlog.mp4', '00:15:30', 'thumb3.jpg', 2000, 150, 5, 'hidden', 3, NOW(), 'Mi viaje a Cancún');

-- Etiquetas
INSERT INTO tags (name) VALUES
('Gaming'),
('Música'),
('Viajes'),
('Vlogs');

-- Video - Tags
INSERT INTO video_tags (id_post_video, id_tag) VALUES
(1, 1), -- Fortnite = Gaming
(2, 2), -- Despacito = Música
(3, 3), -- Cancún = Viajes
(3, 4); -- Cancún = Vlogs también

-- Suscripciones
INSERT INTO subscription (id_user, id_user_subscribed, date_subscription) VALUES
(2, 1, NOW()), -- Laura se suscribe a Juan
(3, 1, NOW()), -- Carlos se suscribe a Juan
(1, 2, NOW()); -- Juan se suscribe a Laura

-- Reacción a Vídeos
INSERT INTO video_reaction (id_user, id_post_video, like_dislike, date_reaction) VALUES
(2, 1, 'like', NOW()), -- Laura da like a Fortnite
(3, 1, 'like', NOW()), -- Carlos da like a Fortnite
(1, 2, 'like', NOW()); -- Juan da like a Cover Despacito

-- Playlists
INSERT INTO playlist (name, creation_date, state, id_user) VALUES
('Mis Favoritos', NOW(), 'publica', 1),
('Canciones Top', NOW(), 'privada', 2);

-- Playlist - Videos
INSERT INTO playlist_video (id_playlist, id_post_video) VALUES
(1, 1), -- Mis favoritos -> Fortnite
(2, 2); -- Canciones Top -> Despacito

-- Comentarios
INSERT INTO comments (text_comment, date_comment, id_user, id_post_video) VALUES
('¡Qué buena partida!', NOW(), 2, 1),
('¡Me encanta tu voz!', NOW(), 1, 2),
('Qué lindo lugar', NOW(), 1, 3);

-- Reacción a Comentarios
INSERT INTO reation_comments (id_user, id_comment, like_dislike, data_reation) VALUES
(1, 1, 'like', NOW()), -- Juan da like al comentario de Laura en Fortnite
(2, 2, 'like', NOW()); -- Laura da like al comentario de Juan en Despacito

-- CONSULTAS

-- top 3 videos mas vistos

SELECT title, number_views
FROM post_videos
ORDER BY number_views DESC
LIMIT 3;

--  Número de likes por cada vídeo

SELECT pv.title, COUNT(vr.like_dislike) AS total_likes
FROM post_videos pv
LEFT JOIN video_reaction vr ON pv.id_post_video = vr.id_post_video AND vr.like_dislike = 'like'
GROUP BY pv.id_post_video
ORDER BY total_likes DESC;




