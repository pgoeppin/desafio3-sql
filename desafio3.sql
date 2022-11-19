CREATE DATABASE "desafio3-Pablo-Goeppinger-325";
\c desafio3-Pablo-Goeppinger-325

-- PREGUNTA 1
-- Crea y agrega al entregable las consultas para completar el setup de acuerdo a lo pedido

CREATE TABLE IF NOT EXISTS users(id SERIAL PRIMARY KEY, email VARCHAR, name VARCHAR, last_name VARCHAR, role VARCHAR);
CREATE TABLE IF NOT EXISTS posts(id SERIAL PRIMARY KEY, title VARCHAR, content TEXT, date_created TIMESTAMP, date_update TIMESTAMP, highlited BOOLEAN, user_id BIGINT);
CREATE TABLE IF NOT EXISTS comments(id SERIAL PRIMARY KEY, content TEXT, date_created TIMESTAMP, user_id BIGINT, post_id BIGINT);

INSERT INTO users(email, name, last_name, role)
VALUES ('pperez@gmail.com', 'Pablo', 'Perez', 'Administrador');
INSERT INTO users(email, name, last_name, role)
VALUES ('jgarcia@gmail.com', 'Jorge', 'Garcia', 'Usuario');
INSERT INTO users(email, name, last_name, role)
VALUES ('hsimpson@gmail.com', 'Homero', 'Simpson', 'Usuario');
INSERT INTO users(email, name, last_name, role)
VALUES ('ccarlson@gmail.com', 'Carl', 'Carlson', 'Usuario');
INSERT INTO users(email, name, last_name, role)
VALUES ('jalvarez@gmail.com', 'Joaquin', 'Alvarez', 'Usuario');

INSERT INTO posts(title,content,date_created, date_update,highlited,user_id)
VALUES ('Primer post', 'Primer post del sitio', '2022-11-12', '2022-11-13', false, 1);
INSERT INTO posts(title,content,date_created, date_update,highlited,user_id)
VALUES ('Bienvenidos', 'Bienvenidos al sitio!', '2022-11-14', '2022-11-15', true, 1);
INSERT INTO posts(title,content,date_created, date_update,highlited,user_id)
VALUES ('Youtube2021', 'Canales de youtube con mas suscripciones en 2021', '2022-11-17', '2022-11-18', true, 3);
INSERT INTO posts(title,content,date_created, date_update,highlited,user_id)
VALUES ('Autos2021', 'Autos mas vendidos en 2021', '2022-11-17', '2022-11-19', false, 4);
INSERT INTO posts(title,content,date_created, date_update,highlited,user_id)
VALUES ('Compras', 'Listado de compras', '2022-11-17', '2022-11-18', false, null);

INSERT INTO comments(content, date_created, user_id, post_id)
VALUES ('Primer comentario', '2022-11-15', 1, 1);
INSERT INTO comments(content, date_created, user_id, post_id)
VALUES ('Segundo comentario', '2022-11-15', 2, 1);
INSERT INTO comments(content, date_created, user_id, post_id)
VALUES ('Tercer comentario', '2022-11-17', 3, 1);
INSERT INTO comments(content, date_created, user_id, post_id)
VALUES ('Cualquier duda al respecto me preguntan', '2022-11-16', 1, 2);
INSERT INTO comments(content, date_created, user_id, post_id)
VALUES ('Probando comentarios', '2022-11-16', 2, 2);

-- PREGUNTA 2
-- Cruza los datos de la tabla usuarios y posts mostrando las siguientes columnas.
-- nombre e email del usuario junto al título y contenido del post.

SELECT users.email, posts.title, posts.content FROM posts
INNER JOIN users ON posts.user_id = users.id;

-- PREGUNTA 3
-- Muestra el id, título y contenido de los posts de los administradores. El
-- administrador puede ser cualquier id y debe ser seleccionado dinámicamente.

SELECT posts.id, posts.title, posts.content FROM posts 
INNER JOIN users ON posts.user_id = users.id
WHERE users.role = 'Administrador';

-- PREGUNTA 4
-- Cuenta la cantidad de posts de cada usuario. La tabla resultante debe mostrar el id
-- e email del usuario junto con la cantidad de posts de cada usuario

SELECT users.id, users.email, COUNT(posts.user_id) FROM posts
RIGHT JOIN users ON posts.user_id = users.id
GROUP BY users.id, users.email;

-- PREGUNTA 5
-- Muestra el email del usuario que ha creado más posts. Aquí la tabla resultante tiene
-- un único registro y muestra solo el email.

SELECT users.email FROM posts
RIGHT JOIN users ON posts.user_id = users.id
GROUP BY users.email
ORDER BY count(posts.user_id) DESC
LIMIT 1;

-- PREGUNTA 6
-- Muestra la fecha del último post de cada usuario.

SELECT users.name, MAX(posts.date_created) FROM posts
INNER JOIN users ON posts.user_id = users.id
GROUP BY users.name;

-- PREGUNTA 7
-- Muestra el título y contenido del post (artículo) con más comentarios. 

SELECT posts.title, posts.content FROM posts 
LEFT JOIN comments ON posts.id = comments.post_id
GROUP BY posts.title, posts.content
ORDER BY COUNT(comments.id) DESC
LIMIT 1;

-- PREGUNTA 8 
-- Muestra en una tabla el título de cada post, el contenido de cada post y el contenido
-- de CADA COMENTARIO (LOS 5 COMENTARIOS (3 en el primer post y 2 en el segundo post como se indica en las instrucciones del desafio))
-- asociado a los posts mostrados, junto con el email del usuario que lo escribió 
-- (2 comentarios escritos por usuario 1, 2 escritos por usuario 2 y 1 escrito por usuario 3).

SELECT posts.title AS "titulo_post", posts.content AS "contenido_post", comments.content AS "contenido_comentario", users.email
FROM posts
LEFT JOIN comments ON posts.id = comments.post_id
INNER JOIN users ON comments.user_id = users.id;

-- PREGUNTA 9
-- Muestra el contenido del último comentario de cada usuario.

SELECT c1.date_created, c1.content, c1.user_id FROM comments c1
INNER JOIN (SELECT MAX(date_created) AS fecha_creacion, user_id FROM comments GROUP BY user_id) AS c2 ON c2.user_id = c1.user_id
AND c2.fecha_creacion = c1.date_created;

-- PREGUNTA 10
-- Muestra los emails de los usuarios que no han escrito ningún comentario.

SELECT users.email FROM users
LEFT JOIN posts ON users.id = posts.user_id
GROUP BY users.email HAVING count(posts.user_id) = 0;

-- \c postgres
-- DROP DATABASE "desafio3-Pablo-Goeppinger-325";