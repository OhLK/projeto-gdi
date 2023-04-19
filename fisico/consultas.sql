-- 1) GROUP BY / HAVING

-- 1.A) Agrupar os generos musicais que tiveram mais de 1 música inseridas no BD, e suas quantidades
SELECT MUSICA.GENERO, COUNT(MUSICA.ID) AS QUANTIDADE
FROM MUSICA
GROUP BY GENERO
HAVING COUNT(MUSICA.ID) > 1;

-- 2) JUNÇÃO INTERNA

-- 2.A) Agrupar quantos prêmios as organizações ganharam (dentre as que ganharam mais de 1 prêmio), com as quantidades na ordem decrescente
SELECT ORGANIZACAO.NOME, COUNT(GANHA.ID_ORGANIZACAO)
FROM ORGANIZACAO INNER JOIN GANHA
ON ORGANIZACAO.ID = GANHA.ID_ORGANIZACAO
GROUP BY ORGANIZACAO.NOME
HAVING COUNT(GANHA.ID_ORGANIZACAO) > 1
ORDER BY COUNT(GANHA.ID_ORGANIZACAO) DESC;

-- 3) JUNÇÃO EXTERNA

-- 3.A) Nomes de todos os usuários, e seus cargos (se eles tiverem)
SELECT U.NOME, A.CARGO
FROM USUARIO U LEFT OUTER JOIN ADMIN_ A ON U.CPF = A.ID
ORDER BY U.NOME ASC;

-- 4) SEMI JUNÇÃO

-- 4.A) Artistas que cantaram
SELECT ARTISTA.NOME
FROM ARTISTA
WHERE EXISTS
	(SELECT * FROM CANTA WHERE ARTISTA.ID = CANTA.ID_ART);

-- 5) ANTI-JUNÇÃO

-- 5.A) Usuários que não são administradores
SELECT USUARIO.NOME
FROM USUARIO
WHERE NOT EXISTS (
    SELECT 1
    FROM ADMIN_
    WHERE ADMIN_.ID = USUARIO.CPF
);

-- 5.B) Usuários que não são comuns
SELECT USUARIO.NOME
FROM USUARIO
WHERE NOT EXISTS (
    SELECT 1
    FROM COMUM
    WHERE COMUM.ID = USUARIO.CPF
);

-- 6) SUBCONSULTA DO TIPO ESCALAR

-- 6.A) Número de músicas que cada artista canta
SELECT ARTISTA.NOME, 
    (
    SELECT COUNT(*)
    FROM CANTA
    WHERE CANTA.ID_ART = ARTISTA.ID
    ) AS NUMERO_DE_MUSICAS
FROM ARTISTA;

-- 7) SUBCONSULTA DO TIPO LINHA

-- 7.A) Selecionar usuários que são comuns
SELECT USUARIO.NOME, USUARIO.CPF
FROM USUARIO
WHERE USUARIO.CPF IN (
    SELECT COMUM.ID
    FROM COMUM
)

-- 8) SUBCONSULTA DO TIPO TABELA

-- 8.A) Nome e gênero das músicas tocadas por um artista
SELECT MUSICA.NOME, MUSICA.GENERO
FROM MUSICA
WHERE (MUSICA.ID, MUSICA.NUM) IN (
    SELECT CANTA.ID, CANTA.NUM
    FROM CANTA
    INNER JOIN ARTISTA ON CANTA.ID_ART = ARTISTA.ID
    WHERE ARTISTA.NOME = 'Timon Willis'
);

-- 9) OPERAÇÃO DE CONJUNTO

-- 9.A) Selecionar artistas que tocam e cantam
SELECT A.NOME
FROM ARTISTA A
WHERE A.ID IN (
    SELECT T.ID_MUS
    FROM TOCA T INNER JOIN MUSICA M ON T.ID_CANTA = M.ID AND T.ID_NUM = M.NUM
    INTERSECT
    SELECT C.ID_ART
    FROM CANTA C INNER JOIN ARTISTA A ON C.ID_ART = A.ID
)