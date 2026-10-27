DROP TABLE IF EXISTS ArticleReviews;
DROP TABLE IF EXISTS Article;
DROP TABLE IF EXISTS ArticleStatuses;
DROP TABLE IF EXISTS Rubric;
DROP TABLE IF EXISTS User;
DROP TABLE IF EXISTS UserRole;

CREATE TABLE UserRole (
    userRoleID INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE User (
    userID INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    surname TEXT NOT NULL,
    patronymic TEXT,
    login TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    userRoleID INTEGER NOT NULL,
    FOREIGN KEY (userRoleID) REFERENCES UserRole(userRoleID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE Rubric (
    rubricID INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE ArticleStatuses (
    articleStatusID INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE Article (
    articleID INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    text TEXT NOT NULL,
    createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME,
    authorID INTEGER NOT NULL,
    rubricID INTEGER NOT NULL,
    statusID INTEGER NOT NULL,
    FOREIGN KEY (authorID) REFERENCES User(userID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (rubricID) REFERENCES Rubric(rubricID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (statusID) REFERENCES ArticleStatuses(articleStatusID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE ArticleReviews (
    reviewID INTEGER PRIMARY KEY AUTOINCREMENT,
    editorID INTEGER NOT NULL,
    articleID INTEGER NOT NULL,
    decision TEXT NOT NULL
        CHECK (decision IN ('Принять', 'Отклонить', 'Вернуть на доработку')),
    comment TEXT,
    reviewedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (editorID) REFERENCES User(userID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (articleID) REFERENCES Article(articleID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

INSERT INTO UserRole (userRoleID, name) VALUES
    (1, 'Администратор'),
    (2, 'Автор'),
    (3, 'Редактор');

INSERT INTO User (
    userID,
    name,
    surname,
    patronymic,
    login,
    password_hash,
    userRoleID
) VALUES
    (1, 'Иван', 'Петров', 'Алексеевич', 'admin', 'demo_hash_admin', 1),
    (2, 'Анна', 'Смирнова', 'Сергеевна', 'author_anna', 'demo_hash_author_anna', 2),
    (3, 'Максим', 'Кузнецов', 'Олегович', 'editor_max', 'demo_hash_editor_max', 3),
    (4, 'Елена', 'Волкова', 'Андреевна', 'author_elena', 'demo_hash_author_elena', 2),
    (5, 'Ольга', 'Соколова', 'Игоревна', 'editor_olga', 'demo_hash_editor_olga', 3);

INSERT INTO Rubric (rubricID, name) VALUES
    (1, 'Наука'),
    (2, 'Технологии'),
    (3, 'Культура');

INSERT INTO ArticleStatuses (articleStatusID, name) VALUES
    (1, 'Черновик'),
    (2, 'На проверке'),
    (3, 'На доработке'),
    (4, 'Принята'),
    (5, 'Отклонена');

INSERT INTO Article (
    articleID,
    title,
    text,
    createdAt,
    updatedAt,
    authorID,
    rubricID,
    statusID
) VALUES
    (1, 'Искусственный интеллект в образовании',
     'Обзор способов применения искусственного интеллекта в учебном процессе.',
     '2026-09-01 10:00:00', '2026-09-06 14:30:00', 2, 2, 4),
    (2, 'Современная городская культура',
     'Материал о развитии городской культуры и общественных пространств.',
     '2026-09-10 09:15:00', '2026-09-12 16:20:00', 4, 3, 3),
    (3, 'Наблюдение за метеорными потоками',
     'Черновик статьи о способах наблюдения за метеорными потоками.',
     '2026-09-15 18:40:00', NULL, 2, 1, 1),
    (4, 'Этические аспекты цифровизации',
     'Материал об этических вопросах применения цифровых технологий.',
     '2026-09-18 11:25:00', '2026-09-20 13:10:00', 4, 2, 5),
    (5, 'Новые материалы в промышленности',
     'Краткий обзор современных композитных материалов.',
     '2026-09-22 08:50:00', NULL, 2, 1, 2);

INSERT INTO ArticleReviews (
    reviewID,
    editorID,
    articleID,
    decision,
    comment,
    reviewedAt
) VALUES
    (1, 3, 1, 'Вернуть на доработку',
     'Нужно дополнить раздел с примерами использования.',
     '2026-09-03 12:00:00'),
    (2, 5, 1, 'Принять',
     'Замечания исправлены, статья готова к публикации.',
     '2026-09-06 14:30:00'),
    (3, 5, 2, 'Вернуть на доработку',
     'Следует добавить источники и уточнить вывод.',
     '2026-09-12 16:20:00'),
    (4, 3, 4, 'Отклонить',
     'Тема раскрыта недостаточно полно.',
     '2026-09-20 13:10:00');
