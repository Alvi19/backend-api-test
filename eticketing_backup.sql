--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3 (Ubuntu 16.3-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.3 (Ubuntu 16.3-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_logs (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    entity text,
    entity_id uuid,
    action text,
    payload jsonb,
    created_at timestamp with time zone DEFAULT now(),
    performed_by uuid
);


ALTER TABLE public.audit_logs OWNER TO postgres;

--
-- Name: cards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cards (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    card_number text NOT NULL,
    balance bigint DEFAULT 0 NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    issued_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.cards OWNER TO postgres;

--
-- Name: fares; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fares (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    from_terminal uuid NOT NULL,
    to_terminal uuid NOT NULL,
    amount bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.fares OWNER TO postgres;

--
-- Name: gates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gates (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    terminal_id uuid NOT NULL,
    code text NOT NULL,
    name text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.gates OWNER TO postgres;

--
-- Name: sync_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sync_logs (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    gate_id uuid,
    payload jsonb,
    sent_at timestamp with time zone DEFAULT now(),
    status text DEFAULT 'pending'::text
);


ALTER TABLE public.sync_logs OWNER TO postgres;

--
-- Name: terminals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.terminals (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    code text NOT NULL,
    name text NOT NULL,
    location text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.terminals OWNER TO postgres;

--
-- Name: topups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.topups (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    card_id uuid NOT NULL,
    amount bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    status text DEFAULT 'completed'::text NOT NULL
);


ALTER TABLE public.topups OWNER TO postgres;

--
-- Name: transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    external_tx_id text,
    card_id uuid NOT NULL,
    type text NOT NULL,
    terminal_id uuid,
    gate_id uuid,
    related_terminal_id uuid,
    amount bigint DEFAULT 0,
    balance_before bigint,
    balance_after bigint,
    created_at timestamp with time zone DEFAULT now(),
    status text DEFAULT 'pending'::text NOT NULL,
    notes text,
    CONSTRAINT transactions_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'processed'::text, 'conflict'::text, 'failed'::text]))),
    CONSTRAINT transactions_type_check CHECK ((type = ANY (ARRAY['checkin'::text, 'checkout'::text, 'topup'::text, 'reversal'::text])))
);


ALTER TABLE public.transactions OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    username text NOT NULL,
    password_hash text NOT NULL,
    role text DEFAULT 'operator'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_logs (id, entity, entity_id, action, payload, created_at, performed_by) FROM stdin;
\.


--
-- Data for Name: cards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cards (id, card_number, balance, status, issued_at, updated_at) FROM stdin;
\.


--
-- Data for Name: fares; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fares (id, from_terminal, to_terminal, amount, created_at) FROM stdin;
\.


--
-- Data for Name: gates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gates (id, terminal_id, code, name, created_at) FROM stdin;
\.


--
-- Data for Name: sync_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sync_logs (id, gate_id, payload, sent_at, status) FROM stdin;
\.


--
-- Data for Name: terminals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.terminals (id, code, name, location, created_at) FROM stdin;
dd57ba33-4267-45bf-ab06-0a77250814e9	T1	Terminal 1	Lokasi 1	2025-10-01 23:58:58.179406+07
fe731151-fc26-406b-a9cc-f5f6f3d28906	T2	Terminal 2	Lokasi 2	2025-10-01 23:59:14.144641+07
fe775dc4-07be-424c-a1a8-7b0a4827b621	T3	Terminal 3	Lokasi 3	2025-10-02 00:09:00.397519+07
\.


--
-- Data for Name: topups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.topups (id, card_id, amount, created_at, status) FROM stdin;
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions (id, external_tx_id, card_id, type, terminal_id, gate_id, related_terminal_id, amount, balance_before, balance_after, created_at, status, notes) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, password_hash, role, created_at) FROM stdin;
00000000-0000-0000-0000-000000000001	admin	$2b$12$5mdRgpg7qpMYi7tHReZihupaEFYFHM/s4a0mNzehKVKz5zxvYTkqy	admin	2025-10-01 23:25:58.566+07
\.


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: cards cards_card_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards
    ADD CONSTRAINT cards_card_number_key UNIQUE (card_number);


--
-- Name: cards cards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards
    ADD CONSTRAINT cards_pkey PRIMARY KEY (id);


--
-- Name: fares fares_from_terminal_to_terminal_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fares
    ADD CONSTRAINT fares_from_terminal_to_terminal_key UNIQUE (from_terminal, to_terminal);


--
-- Name: fares fares_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fares
    ADD CONSTRAINT fares_pkey PRIMARY KEY (id);


--
-- Name: gates gates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gates
    ADD CONSTRAINT gates_pkey PRIMARY KEY (id);


--
-- Name: gates gates_terminal_id_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gates
    ADD CONSTRAINT gates_terminal_id_code_key UNIQUE (terminal_id, code);


--
-- Name: sync_logs sync_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sync_logs
    ADD CONSTRAINT sync_logs_pkey PRIMARY KEY (id);


--
-- Name: terminals terminals_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.terminals
    ADD CONSTRAINT terminals_code_key UNIQUE (code);


--
-- Name: terminals terminals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.terminals
    ADD CONSTRAINT terminals_pkey PRIMARY KEY (id);


--
-- Name: topups topups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.topups
    ADD CONSTRAINT topups_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: idx_fares_lookup; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fares_lookup ON public.fares USING btree (from_terminal, to_terminal);


--
-- Name: audit_logs audit_logs_performed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_performed_by_fkey FOREIGN KEY (performed_by) REFERENCES public.users(id);


--
-- Name: fares fares_from_terminal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fares
    ADD CONSTRAINT fares_from_terminal_fkey FOREIGN KEY (from_terminal) REFERENCES public.terminals(id);


--
-- Name: fares fares_to_terminal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fares
    ADD CONSTRAINT fares_to_terminal_fkey FOREIGN KEY (to_terminal) REFERENCES public.terminals(id);


--
-- Name: gates gates_terminal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gates
    ADD CONSTRAINT gates_terminal_id_fkey FOREIGN KEY (terminal_id) REFERENCES public.terminals(id) ON DELETE CASCADE;


--
-- Name: sync_logs sync_logs_gate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sync_logs
    ADD CONSTRAINT sync_logs_gate_id_fkey FOREIGN KEY (gate_id) REFERENCES public.gates(id);


--
-- Name: topups topups_card_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.topups
    ADD CONSTRAINT topups_card_id_fkey FOREIGN KEY (card_id) REFERENCES public.cards(id);


--
-- Name: transactions transactions_card_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_card_id_fkey FOREIGN KEY (card_id) REFERENCES public.cards(id);


--
-- Name: transactions transactions_gate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_gate_id_fkey FOREIGN KEY (gate_id) REFERENCES public.gates(id);


--
-- Name: transactions transactions_related_terminal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_related_terminal_id_fkey FOREIGN KEY (related_terminal_id) REFERENCES public.terminals(id);


--
-- Name: transactions transactions_terminal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_terminal_id_fkey FOREIGN KEY (terminal_id) REFERENCES public.terminals(id);


--
-- PostgreSQL database dump complete
--

