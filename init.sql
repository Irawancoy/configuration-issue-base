CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE note (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    content TEXT NOT NULL
);
