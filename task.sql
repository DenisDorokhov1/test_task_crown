CREATE TABLE companies (
    id INTEGER PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    inn VARCHAR(12) UNIQUE NOT NULL
);

CREATE TABLE tenders (
    id INTEGER PRIMARY KEY,
    tender_num VARCHAR(255) UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    company_id INTEGER NOT NULL,
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    status VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE RESTRICT
);

CREATE TABLE lots (
    id INTEGER PRIMARY KEY,
    tender_id INTEGER NOT NULL,
    lot_num INTEGER NOT NULL,
    title TEXT NOT NULL,
    initial_price DECIMAL NOT NULL CHECK (initial_price >= 0),
    FOREIGN KEY (tender_id) REFERENCES tenders(id) ON DELETE CASCADE,
    UNIQUE (tender_id, lot_num)
);

CREATE TABLE contractor (
    id INTEGER PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    inn VARCHAR(12) UNIQUE NOT NULL
);

CREATE TABLE bids (
    id INTEGER PRIMARY KEY,
    lot_id INTEGER NOT NULL,
    contractor_id INTEGER NOT NULL,
    amount DECIMAL NOT NULL CHECK (amount >= 0),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) NOT NULL,
    FOREIGN KEY (lot_id) REFERENCES lots(id) ON DELETE CASCADE,
    FOREIGN KEY (contractor_id) REFERENCES contractor(id) ON DELETE CASCADE
);

CREATE INDEX idx_tenders_company_id
    ON tenders(company_id);

CREATE INDEX idx_tenders_start_date
    ON tenders(start_date);

CREATE INDEX idx_tenders_end_date
    ON tenders(end_date);

CREATE INDEX idx_lots_tender_id
    ON lots(tender_id);

CREATE INDEX idx_bids_lot_id
    ON bids(lot_id);

CREATE INDEX idx_bids_contractor_id
    ON bids(contractor_id);

CREATE INDEX idx_bids_created_at
    ON bids(created_at);