CREATE TABLE Event (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    crontab TEXT NOT NULL,
    message TEXT NOT NULL,
    counter INTEGER NOT NULL
);
