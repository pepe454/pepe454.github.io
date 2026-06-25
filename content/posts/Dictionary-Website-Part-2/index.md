+++
date = '2026-06-25T11:25:58-04:00'
draft = false
title = 'Dictionary Website, Part 2: Database Design'
tags = ['Programming', 'Projects', 'Dictionary', 'Sourashtra', 'Docker', 'Databases', 'Postgres', 'PgAdmin']
+++

The first step in building the dictionary is data design. I will be using Postgress as a SQL relational database,
and using PgAdmin to assist in the design of the tables and their relationships.

## Building the Database

My choice for core technology underpinning the data of the website will be a relational database. 
Due to the relational nature of language data, especially for my features which will include words in-situ,
as well as translations from english to sourashtra and vice-versa, a database is perfectly suited to the task.
Moreover, there are database utilities that will allow for search and even fuzzy matching, so stay tuned for that later!

## Docker Compose Setup

Below is my initial docker compose setup. I have designed it to have a postgres database with pgadmin as an admin website 
to access the database and design the Entity-Relationship diagram.

```yaml
name: joman

services:
  postgres:
    image: postgres:18.3-alpine3.22
    container_name: postgres
    restart: always
    shm_size: 128mb
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB}"]
      interval: 10s
      retries: 5
      start_period: 30s
      timeout: 10s
    ports:
      - "${POSTGRES_PORT}:5432"
    env_file: .env
    volumes:
      - pgdata:/var/lib/postgresql/data/pgdata

  pgadmin:
    image: dpage/pgadmin4:2026-03-03-1
    container_name: pgadmin
    restart: always
    env_file: .env
    depends_on:
      - postgres
    ports:
      - "8000:80"
    volumes:
      - pgadmin-data:/var/lib/pgadmin

volumes:
  pgdata:
  pgadmin-data:
```


You will also notice that there is a referenced .env file. Here is an example of the variables:

```bash
# Postgres
POSTGRES_SERVER=localhost
POSTGRES_PORT=5432
POSTGRES_DB=joman
POSTGRES_USER=dbadmin
POSTGRES_PASSWORD=changethis
POSTGRES_URL=postgres://dbadmin:changethis@localhost:5432/pgdatabase
PGADMIN_DEFAULT_EMAIL=changme@example.com
PGADMIN_DEFAULT_PASSWORD=changethis
```

All of these environment variables will allow me to statically set up admin users and passwords, which I will use to login and
update the database.


After setting up the environment variables, I need to download the docker images. You can simply do docker compose up: 
```shell
$ docker compose up -d
```
and the images will pull automatically from the postgres and pgadmin docker repositories on dockerhub.

After doing that, I am rewarded with the following admin page at localhost:8000:
![PgAdmin Login Page](./PGAdmin.png)

After entering the credentials, enter the database admin credentials set in the .env file:
![PgAdmin Server Page](./PGAdminServer.png)
![PgAdmin Server Page2](./PGAdminServer2.png)

Awesome, now we are logged in to PgAdmin!


## Entity Relationship Diagrams

The most important step now in the database design is how I set up the tables. Using database design principles,
I will organize the schema to allow for sensible joins using foreign keys, allowing me to express the relationships in my data.

Once you login to PGAdmin, you can go into the database and create a new ER Diagram:

![PgAdmin Server Setup ER diagram](./PGAdmin-ERD-Setup.png)

This is a really easy and intuitive way to create database tables. Instead of using SQL Data Definition Language (DDL) directly, 
I can simply design the tables using an easy interface and focus on the parts that matter.


#### Words: The Foundation of the database

The first table I will design is the words table. This is very important and will be the fundamental building block of the database.
All other tables will be related to this table in some way.

Now that I'm in the ER Diagram page, I can set up the words table like so:
![PgAdmin Words](./PGAdminERD2.png)

A couple of notes here:
- I've decided to go with word_id as a pk auto-incrementing id (serial data type) to ensure uniqueness.
- Word text will be the real text of the word. for sourashtra I will use english characters to phonetically write words.
- language and part_of_speech will directly reference other tables, but I will use the values directly so that 
I don't have to join with the other tables every time I want to read out a word.
- word_text_alt gives me the ability to write other characters, for example writing the word in sourashtra lipi. 
- audio_file_path also gives me the ability to later add the words audio files, which will be referenced in filepaths and stored on the filesystem.

Excellent. Now that I've set up the words, it's time to set up the rest of the database. I've decided to leverage the 
relational power of SQL to connect this words table to other tables


#### Translations 

First is translations - these will be a many-to-many mapping from sourashtra words to other words. 
![PgAdmin Translations](./PGAdmin-Translations.png)

This design is very flexible, because it allows me to add Tamil translations or any other language's translation without 
modifying the schema or the design. Also, because I am primarily focused on translating sourashtra, I can do a specific 
Sourashtra word translated to a Tamil or English word. Otherwise, I would have 2-way translations, potentially getting 
quite messy. 

![PgAdmin Translations](./PGAdminERD-FK.png)

After you set up the foreign keys, be sure to set up cascade on delete. You do not want old translations lying around 
for a word that you have already deleted!

![PgAdmin Translations](./PGAdminERD-FK2.png)

The other nice part about this design is that I can have multiple translations for a single word. 
Namely, if a sourashtra word has multiple meanings in English, I can simply have multiple rows in this table. 
This is the beauty of a many-to-many table also known as a join table or mapping table.


#### Sentences

The other table I have set up is sentences. This is a full text sentence table, which will have mappings from each 
sentence to constituent parts, via the word_in_context table

![PgAdmin Sentences](./PGAdmin-Sentences.png)

This relation, word in context, allows me to connect many-to-many: one sentence can be connected to many words, and 
one word may be connected to many sentences.

![PgAdmin Sentences](./PGAdmin-WordInContext.png)


#### Categories

In my view, it is very helpful to learn related words. If you are learning about household things, it's helpful to learn 
all the related words, like bed, door, chair, bathroom, kitchen, oven, stove, table, plates, bowls, etc...

![PgAdmin Categories](./PGAdmin-Categories.png)

Thus, I have also set up a categories table. Like the other 2 tables, sentences and translations, this is yet another 
many-to-many relationship. A single word can be a part of multiple categories, and likewise, a category will certainly have 
multiple words.

![PgAdmin Categories](./PGAdmin-WordCategories.png)


#### Word Metadata

Of course, it will also be helpful to have context about each word. We will want to know:
- which language a word is a part of ; and 
- which part of speech corresponds to the word

I could use another foreign key join like the previous tables, but if I want to read a single word, I would have to join it 
with 2 other tables. So instead, I am going to add a foreign key with no id. Doing so will allow me to simply add the word's
part of speech and language directly. Instead of using an Enum type, which restricts usage after creation, I will use a foreign 
key to a table that I can later add to. Using the foreign key will restrict the language and part of speech to a set relationship
on the other tables, but I will not have to join.


![PgAdmin Languages](./PGAdmin-Languages.png)
![PgAdmin PartOfSpeech](./PGAdmin-PartOfSpeech.png)

Ok, I've designed the relations and the foreign keys. Now it's time to create the database.

#### Saving the file

Once I set up the tables, I can now hit this Generate SQL button: 
![PgAdmin Generate SQL](./PGAdminERD3.png)


It will, you guessed it, generate a SQL File for you automatically:
![PgAdmin GeneratED sql](./PGAdmin-Create.png)

```sql
BEGIN;

-- Use non-public schema as default.
CREATE SCHEMA IF NOT EXISTS dictionary;

-- Restrict languages
CREATE TABLE IF NOT EXISTS dictionary.language
(
    language VARCHAR(16) NOT NULL,
    language_alt VARCHAR(16) NULL,
    CONSTRAINT pk_language PRIMARY KEY (language)
);


-- Restrict parts of speech
CREATE TABLE IF NOT EXISTS dictionary.part_of_speech 
(
    part_of_speech VARCHAR(16) NOT NULL,
    CONSTRAINT pk_part_of_speech PRIMARY KEY (part_of_speech)
);

-- more tables follow here...
```

Isn't that just awesome? I love databases. 

However, the not so awesome part is that I'd like to save this file out somewhere:
![PgAdmin Words](./PGAdmin-Save.png)

As you've noticed , this folder is empty. Where could it be? Well, following docker first principles, it is somewhere 
in the container! Lo and behold, if I exec into the container, I am able to find the create script in the container /var/lib dir:

```shell
$ docker exec -it pgadmin /bin/bash
```

```shell
$ docker exec -it pgadmin /bin/bash
$ ls
LICENSE             branding.py         commit_hash         config.py           config_distro.py    docs                gunicorn_config.py  migrations          pgAdmin4.py         pgAdmin4.wsgi       pgacloud            pgadmin             run_pgadmin.py      setup.py            version.py
$ cd /var/lib/pgadmin/storage/pgadmin@email.com/
$ ls
example-script
```

I can use the docker cp command to copy that file from the container to my host to save it for future use:

```shell
$ docker cp joman-pgadmin-1:/var/lib/pgadmin/storage/pgadmin@email.com/example-script.sql ./backend/db/
```

Of course, I could have just copy and pasted into a local file. But I wanted to understand how files were stored in pgadmin.

Also, by doing that , I could also export to PNG and copy that file as well! Here's what I got: 


![Total ER Diagram](./PGAdminERD1.png)


## Creating the schema


You can easily use the psql command to execute the create schema script:

```shell
$ psql -h localhost -p 5432 -U postgresadmin -d joman -f backend/db/create-schema.sql 
```

However, I wanted to make this a repeatable and automated process. I set up a volume on the local drive to 
the entrypoints scripts, which automatically run as soon as the postgres docker container starts up:


```yaml
postgres:
    # ignoring stuff above...
    volumes:
        - pgdata:/var/lib/postgresql/data/pgdata
        - ./backend/db/:/docker-entrypoint-initdb.d/ # init scripts
```

Now, every time I start postgres on a fresh install or if I want to obliterate the existing database,
I can delete the volume and simply docker compose up once again, then this create-schema script will automatically 
run on launch. Dang. I love postgres.


#### Adding some seed data

Having a schema is great and all, but it's kinda boring. You can't do anything with it. It's like having a house with no furniture.

I wanted to be able to test out some queries, so I inserted some words using an initial-seed.sql script:

```sql
BEGIN;

/* This script simply adds the word for mother in all 3 languages with metadata. */

INSERT INTO dictionary.language (language, language_alt) VALUES
    ('Sourashtra', 'ꢱꣃꢬꢵꢰ꣄ꢜ꣄ꢬ'),
    ('English', NULL),
    ('தமிழ்', 'Tamil');


INSERT INTO dictionary.part_of_speech (part_of_speech) VALUES
    ('noun'),
    ('pronoun'),
    ('verb'),
    ('adjective'),
    ('adverb'),
    ('preposition'),
    ('conjunction'),
    ('interjection'),
    ('numeral'),
    ('article'),
    ('interrogative');


INSERT INTO dictionary.word (word_text, language, part_of_speech, word_text_alt) VALUES
    ('ambO', 'Sourashtra', 'noun', 'ꢂꢪ꣄ꢨꣁ'),
    ('mother', 'English', 'noun', NULL),
    ('அம்மா', 'தமிழ்', 'noun', 'amma');


INSERT INTO dictionary.translation (sourashtra_word_id, other_word_id, context) VALUES
    (1, 2, NULL),
    (1, 3, NULL);


INSERT INTO dictionary.category (category) VALUES
    ('family'), -- always put family first!
    -- these are all parts of speech
    ('adjectives'),
    ('adverbs'),
    ('pronouns'),
    ('verbs'),
    ('questions'),
    ('numbers'),
    ('conjunctions'),
    ('prepositions'),
    ('animals'),
    ('body'),
    ('clothing'),
    ('cognition'),
    ('colors'),
    ('feelings'),
    ('food'),
    ('house'),
    ('nature'),
    ('people'),
    ('places'),
    ('taste'),
    ('time');


INSERT INTO dictionary.word_category (word_id, category_id) VALUES
    (1, 1), -- sourashtra ambO -> family
    (2, 1), -- english    mother -> family
    (3, 1); -- tamil      ammo -> family

END;
```


After doing that, I could test the schema out. First, connect to the database (install psql client first):
```shell
$ psql -h localhost -p 5432 -U dbadmin -d joman
```

Once I'm in the database, now I can check out the relations, using the `\dt` command:

List of tables:
| Schema | Name | Type | Owner |
|--------|------|------|-------|
| dictionary | category | table | postgresadmin |
| dictionary | language | table | postgresadmin |
| dictionary | part_of_speech | table | postgresadmin |
| dictionary | sentence | table | postgresadmin |
| dictionary | sentence_translation | table | postgresadmin |
| dictionary | translation | table | postgresadmin |
| dictionary | word | table | postgresadmin |
| dictionary | word_category | table | postgresadmin |
| dictionary | word_in_context | table | postgresadmin |


I can also check out a specific table by typing `\d word` :

**Table "dictionary.word"**

| Column | Type | Nullable | Default |
|--------|------|----------|---------|
| word_id | integer | not null | nextval('word_word_id_seq'::regclass) |
| word_text | text | not null | |
| language | character varying(16) | not null | |
| part_of_speech | character varying(16) | not null | |
| word_text_alt | text | | |
| audio_file_path | text | | |

**Indexes:**
- `pk_word` PRIMARY KEY, btree (word_id)
- `fki_fk_word_language` btree (language)
- `fki_fk_word_part_of_speech` btree (part_of_speech)
- `word_text_distinct` UNIQUE CONSTRAINT, btree (word_text, language)

**Foreign-key constraints:**
- `fk_word_language` FOREIGN KEY (language) REFERENCES language(language) ON DELETE RESTRICT
- `fk_word_part_of_speech` FOREIGN KEY (part_of_speech) REFERENCES part_of_speech(part_of_speech) ON UPDATE CASCADE ON DELETE RESTRICT

**Referenced by:**
- TABLE `translation` CONSTRAINT `fk_other_word_id` FOREIGN KEY (other_word_id) REFERENCES word(word_id) ON UPDATE CASCADE ON DELETE CASCADE
- TABLE `translation` CONSTRAINT `fk_sourashtra_word_id` FOREIGN KEY (sourashtra_word_id) REFERENCES word(word_id) ON UPDATE CASCADE ON DELETE CASCADE
- TABLE `word_category` CONSTRAINT `fk_word_id_to_category` FOREIGN KEY (word_id) REFERENCES word(word_id) ON UPDATE CASCADE ON DELETE CASCADE
- TABLE `word_in_context` CONSTRAINT `fk_word_word_in_ctxt` FOREIGN KEY (word_id) REFERENCES word(word_id) ON UPDATE CASCADE ON DELETE CASCADE


Lovely. Now that I have confirmed the tables are created and set up, I can write some queries! 


Here is one query to get the words matched to their respective categories:

```sql
select w.word_id,
       w.word_text,
       c.category
from dictionary.word w
inner join dictionary.word_category wc on w.word_id = wc.word_id
inner join dictionary.category c on c.category_id = wc.category_id
```


I get this output, as expected:

| word_id | word_text | category |
|---------|-----------|----------|
| 1 | ambO | family |
| 2 | mother | family |
| 3 | அம்மா | family |



This query will tranlsate sourashtra words for me:

```sql
with sourashtra_words as (
    select word_id, word_text, part_of_speech 
    from word
    where language = 'Sourashtra'
),
other_words as (
    select word_id, word_text, word_text_alt
    from word 
    where language != 'Sourashtra'
)

select sourashtra_words.*,
       other_words.*
from sourashtra_words 
join translation wt
on sourashtra_words.word_id = wt.sourashtra_word_id
join other_words
on other_words.word_id = wt.other_word_id
```

| word_id | word_text | part_of_speech | word_id | word_text | word_text_alt |
|---------|-----------|----------------|---------|-----------|---------------|
| 1 | ambO | noun | 2 | mother | |
| 1 | ambO | noun | 3 | அம்மா | amma |


## Recap 

I covered a lot on this post, but we are just getting started. The next step is to build out the 
language corpus and start seeding some data into the db!
