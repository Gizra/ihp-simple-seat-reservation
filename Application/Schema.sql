CREATE FUNCTION set_updated_at_to_now() RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language plpgsql;
-- Your database schema. Use the Schema Designer at http://localhost:8001/ to add some tables.
CREATE TYPE reservation_status AS ENUM ('accepted', 'rejected', 'queued');
CREATE TABLE venues (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    title TEXT NOT NULL,
    total_number_of_seats INT NOT NULL
);
CREATE TABLE events (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    start_time TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    end_time TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    venue_id UUID NOT NULL,
    title TEXT NOT NULL
);
CREATE TABLE reservations (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    event_id UUID NOT NULL,
    seat_number INT NOT NULL,
    person_identifier TEXT NOT NULL,
    status reservation_status NOT NULL,
    delay BOOLEAN DEFAULT false NOT NULL
);
CREATE TABLE reservation_jobs (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    status JOB_STATUS DEFAULT 'job_status_not_started' NOT NULL,
    last_error TEXT DEFAULT NULL,
    attempts_count INT DEFAULT 0 NOT NULL,
    locked_at TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    locked_by UUID DEFAULT NULL,
    run_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    reservation_id UUID NOT NULL
);
ALTER TABLE events ADD CONSTRAINT events_ref_venue_id FOREIGN KEY (venue_id) REFERENCES venues (id) ON DELETE NO ACTION;
ALTER TABLE reservation_jobs ADD CONSTRAINT reservation_jobs_ref_reservation_id FOREIGN KEY (reservation_id) REFERENCES reservations (id) ON DELETE CASCADE;
ALTER TABLE reservations ADD CONSTRAINT reservations_ref_event_id FOREIGN KEY (event_id) REFERENCES events (id) ON DELETE NO ACTION;


CREATE TABLE events_revisions ( revision SERIAL NOT NULL) INHERITS (events);

CREATE OR REPLACE FUNCTION table_update() RETURNS TRIGGER AS $table_update$
    BEGIN
        INSERT INTO events_revisions SELECT NEW.*;
        RETURN NEW;
    END;
$table_update$ LANGUAGE plpgsql;

CREATE TRIGGER table_update
AFTER INSERT OR UPDATE ON events
    FOR EACH ROW EXECUTE PROCEDURE table_update();