-- Database: academic

CREATE TABLE academic.author (
    aid INTEGER PRIMARY KEY,
    homepage TEXT,
    name TEXT,
    oid INTEGER
);

CREATE TABLE academic.conference (
    cid INTEGER PRIMARY KEY,
    homepage TEXT,
    name TEXT
);

CREATE TABLE academic.domain (
    did INTEGER PRIMARY KEY,
    name TEXT
);

CREATE TABLE academic.domain_author (
    aid INTEGER,
    did INTEGER PRIMARY KEY
);

CREATE TABLE academic.domain_conference (
    cid INTEGER,
    did INTEGER PRIMARY KEY
);

CREATE TABLE academic.journal (
    homepage TEXT,
    jid INTEGER PRIMARY KEY,
    name TEXT
);

CREATE TABLE academic.domain_journal (
    did INTEGER PRIMARY KEY,
    jid INTEGER
);

CREATE TABLE academic.keyword (
    keyword TEXT,
    kid INTEGER PRIMARY KEY
);

CREATE TABLE academic.domain_keyword (
    did INTEGER PRIMARY KEY,
    kid INTEGER
);

CREATE TABLE academic.publication (
    abstract TEXT,
    cid INTEGER,
    citation_num INTEGER,
    jid INTEGER,
    pid INTEGER PRIMARY KEY,
    reference_num INTEGER,
    title TEXT,
    year INTEGER
);

CREATE TABLE academic.domain_publication (
    did INTEGER PRIMARY KEY,
    pid INTEGER
);

CREATE TABLE academic.organization (
    continent TEXT,
    homepage TEXT,
    name TEXT,
    oid INTEGER PRIMARY KEY
);

CREATE TABLE academic.publication_keyword (
    pid INTEGER,
    kid INTEGER PRIMARY KEY
);

CREATE TABLE academic.writes (
    aid INTEGER PRIMARY KEY,
    pid INTEGER
);

CREATE TABLE academic.cite (
    cited INTEGER,
    citing INTEGER
);

ALTER TABLE academic.domain_author ADD CONSTRAINT fk_domain_author_did_to_domain FOREIGN KEY (did) REFERENCES academic.domain(did);

ALTER TABLE academic.domain_author ADD CONSTRAINT fk_domain_author_aid_to_author FOREIGN KEY (aid) REFERENCES academic.author(aid);

ALTER TABLE academic.domain_conference ADD CONSTRAINT fk_domain_conference_did_to_domain FOREIGN KEY (did) REFERENCES academic.domain(did);

ALTER TABLE academic.domain_conference ADD CONSTRAINT fk_domain_conference_cid_to_conference FOREIGN KEY (cid) REFERENCES academic.conference(cid);

ALTER TABLE academic.domain_journal ADD CONSTRAINT fk_domain_journal_did_to_domain FOREIGN KEY (did) REFERENCES academic.domain(did);

ALTER TABLE academic.domain_journal ADD CONSTRAINT fk_domain_journal_jid_to_journal FOREIGN KEY (jid) REFERENCES academic.journal(jid);

ALTER TABLE academic.domain_keyword ADD CONSTRAINT fk_domain_keyword_did_to_domain FOREIGN KEY (did) REFERENCES academic.domain(did);

ALTER TABLE academic.domain_keyword ADD CONSTRAINT fk_domain_keyword_kid_to_keyword FOREIGN KEY (kid) REFERENCES academic.keyword(kid);

ALTER TABLE academic.publication ADD CONSTRAINT fk_publication_cid_to_conference FOREIGN KEY (cid) REFERENCES academic.conference(cid);

ALTER TABLE academic.publication ADD CONSTRAINT fk_publication_jid_to_journal FOREIGN KEY (jid) REFERENCES academic.journal(jid);

ALTER TABLE academic.domain_publication ADD CONSTRAINT fk_domain_publication_did_to_domain FOREIGN KEY (did) REFERENCES academic.domain(did);

ALTER TABLE academic.domain_publication ADD CONSTRAINT fk_domain_publication_pid_to_publication FOREIGN KEY (pid) REFERENCES academic.publication(pid);

ALTER TABLE academic.publication_keyword ADD CONSTRAINT fk_publication_keyword_kid_to_keyword FOREIGN KEY (kid) REFERENCES academic.keyword(kid);

ALTER TABLE academic.publication_keyword ADD CONSTRAINT fk_publication_keyword_pid_to_publication FOREIGN KEY (pid) REFERENCES academic.publication(pid);

ALTER TABLE academic.writes ADD CONSTRAINT fk_writes_aid_to_author FOREIGN KEY (aid) REFERENCES academic.author(aid);

ALTER TABLE academic.writes ADD CONSTRAINT fk_writes_pid_to_publication FOREIGN KEY (pid) REFERENCES academic.publication(pid);

ALTER TABLE academic.cite ADD CONSTRAINT fk_cite_citing_to_publication FOREIGN KEY (citing) REFERENCES academic.publication(pid);

ALTER TABLE academic.cite ADD CONSTRAINT fk_cite_cited_to_publication FOREIGN KEY (cited) REFERENCES academic.publication(pid);


