--
-- PostgreSQL database dump
--

-- Dumped from database version 12.6 (Debian 12.6-1.pgdg100+1)
-- Dumped by pg_dump version 13.3

-- Started on 2021-06-02 21:51:21 UTC

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
-- TOC entry 3092 (class 1262 OID 16385)
-- Name: spms_erp; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE spms_erp WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


\connect spms_erp

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
-- TOC entry 2 (class 3079 OID 16459)
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- TOC entry 3093 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- TOC entry 689 (class 1247 OID 16565)
-- Name: email; Type: DOMAIN; Schema: public; Owner: -
--

CREATE DOMAIN public.email AS public.citext
	CONSTRAINT email_check CHECK ((VALUE OPERATOR(public.~) '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$'::public.citext));


--
-- TOC entry 274 (class 1255 OID 16709)
-- Name: create_employee(character varying, character varying, character varying, character varying, public.email, date, bytea, text, integer, integer, integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.create_employee(_firstname character varying, _lastname character varying, _phone character varying, _cell character varying, _email public.email, _dob date, _photo bytea, _notes text, _department_id integer, _role_id integer, _manager_id integer, INOUT ret_contact_id integer, INOUT ret_employee_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN

INSERT INTO contact (firstname, lastname, phone, cell, email, dob, photo, notes) VALUES (_firstname, _lastname, _phone, _cell, _email, _dob, _photo, _notes) RETURNING contact.id INTO ret_contact_id;
INSERT INTO employee (contact_id, department_id, job_id, manager_id) VALUES (ret_contact_id, _department_id, _job_id, _manager_id) RETURNING employee.id INTO ret_employee_id;

COMMIT;
END;
$$;


--
-- TOC entry 275 (class 1255 OID 16814)
-- Name: update_employee(character varying, character varying, character varying, character varying, public.email, date, bytea, text, integer, integer, integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.update_employee(_firstname character varying, _lastname character varying, _phone character varying, _cell character varying, _email public.email, _dob date, _photo bytea, _notes text, _department_id integer, _role_id integer, _manager_id integer, _contact_id integer, INOUT _employee_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN

UPDATE contact SET (firstname, lastname, phone, cell, email, dob, photo, notes) = (_firstname, _lastname, _phone, _cell, _email, _dob, _photo, _notes) WHERE id = _contact_id;
UPDATE employee SET (department_id, job_id, manager_id) = (_department_id, _job_id, _manager_id) WHERE id = _employee_id RETURNING id INTO _employee_id;

COMMIT;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 214 (class 1259 OID 17105)
-- Name: role; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.role (
    id integer NOT NULL,
    name character varying(30) NOT NULL
);


--
-- TOC entry 213 (class 1259 OID 17103)
-- Name: authority_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.authority_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3094 (class 0 OID 0)
-- Dependencies: 213
-- Name: authority_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.authority_id_seq OWNED BY public.role.id;


--
-- TOC entry 210 (class 1259 OID 16720)
-- Name: contact; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contact (
    id integer NOT NULL,
    firstname character varying(40) NOT NULL,
    lastname character varying(40) NOT NULL,
    phone character varying(30),
    cell character varying(30),
    email public.email,
    department character varying(40),
    role character varying(40),
    dob date,
    photo bytea,
    notes text
);


--
-- TOC entry 209 (class 1259 OID 16718)
-- Name: contact_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contact_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3095 (class 0 OID 0)
-- Dependencies: 209
-- Name: contact_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contact_id_seq OWNED BY public.contact.id;


--
-- TOC entry 206 (class 1259 OID 16594)
-- Name: department; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.department (
    id integer NOT NULL,
    name character varying(40) NOT NULL
);


--
-- TOC entry 205 (class 1259 OID 16592)
-- Name: department_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.department_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3096 (class 0 OID 0)
-- Dependencies: 205
-- Name: department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.department_id_seq OWNED BY public.department.id;


--
-- TOC entry 204 (class 1259 OID 16443)
-- Name: employee; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employee (
    id integer NOT NULL,
    contact_id integer NOT NULL,
    department_id integer NOT NULL,
    job_id integer NOT NULL,
    manager_id integer
);


--
-- TOC entry 208 (class 1259 OID 16602)
-- Name: job; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job (
    id integer NOT NULL,
    title character varying(40) NOT NULL,
    job_description bytea
);


--
-- TOC entry 216 (class 1259 OID 17142)
-- Name: employee_all_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.employee_all_view AS
 SELECT employee.id,
    employee.contact_id,
    employee.department_id,
    employee.job_id,
    employee.manager_id,
    contact.firstname,
    contact.lastname,
    contact.phone,
    contact.cell,
    contact.email,
    to_char((contact.dob)::timestamp with time zone, 'dd/mm/yyyy'::text) AS dob,
    contact.notes,
    department.name AS department_name,
    job.title
   FROM (((public.employee
     LEFT JOIN public.contact ON ((employee.contact_id = contact.id)))
     LEFT JOIN public.department ON ((employee.department_id = department.id)))
     LEFT JOIN public.job ON ((employee.job_id = job.id)));


--
-- TOC entry 203 (class 1259 OID 16441)
-- Name: employee_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3097 (class 0 OID 0)
-- Dependencies: 203
-- Name: employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employee_id_seq OWNED BY public.employee.id;


--
-- TOC entry 207 (class 1259 OID 16600)
-- Name: role_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3098 (class 0 OID 0)
-- Dependencies: 207
-- Name: role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.role_id_seq OWNED BY public.job.id;


--
-- TOC entry 212 (class 1259 OID 17092)
-- Name: user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    username character varying(30) NOT NULL,
    password character varying NOT NULL,
    email public.email NOT NULL
);


--
-- TOC entry 211 (class 1259 OID 17090)
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3099 (class 0 OID 0)
-- Dependencies: 211
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- TOC entry 215 (class 1259 OID 17113)
-- Name: user_role; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_role (
    user_id integer NOT NULL,
    role_id integer NOT NULL
);


--
-- TOC entry 2918 (class 2604 OID 16723)
-- Name: contact id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contact ALTER COLUMN id SET DEFAULT nextval('public.contact_id_seq'::regclass);


--
-- TOC entry 2916 (class 2604 OID 16597)
-- Name: department id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.department ALTER COLUMN id SET DEFAULT nextval('public.department_id_seq'::regclass);


--
-- TOC entry 2915 (class 2604 OID 16446)
-- Name: employee id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee ALTER COLUMN id SET DEFAULT nextval('public.employee_id_seq'::regclass);


--
-- TOC entry 2917 (class 2604 OID 16605)
-- Name: job id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job ALTER COLUMN id SET DEFAULT nextval('public.role_id_seq'::regclass);


--
-- TOC entry 2920 (class 2604 OID 17108)
-- Name: role id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role ALTER COLUMN id SET DEFAULT nextval('public.authority_id_seq'::regclass);


--
-- TOC entry 2919 (class 2604 OID 17095)
-- Name: user id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- TOC entry 3081 (class 0 OID 16720)
-- Dependencies: 210
-- Data for Name: contact; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.contact (id, firstname, lastname, phone, cell, email, department, role, dob, photo, notes) FROM stdin;
11	Joe	Bloggs	01234 567 890	07123 456 789	j.bloggs@example.com	\N	\N	1970-01-01	\N	 an important note
\.


--
-- TOC entry 3077 (class 0 OID 16594)
-- Dependencies: 206
-- Data for Name: department; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.department (id, name) FROM stdin;
1	Information Systems
\.


--
-- TOC entry 3075 (class 0 OID 16443)
-- Dependencies: 204
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.employee (id, contact_id, department_id, job_id, manager_id) FROM stdin;
16	11	1	1	\N
\.


--
-- TOC entry 3079 (class 0 OID 16602)
-- Dependencies: 208
-- Data for Name: job; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.job (id, title, job_description) FROM stdin;
1	Full Stack Web Developer	\N
\.


--
-- TOC entry 3085 (class 0 OID 17105)
-- Dependencies: 214
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.role (id, name) FROM stdin;
1	user
2	moderator
3	admin
\.


--
-- TOC entry 3083 (class 0 OID 17092)
-- Dependencies: 212
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."user" (id, username, password, email) FROM stdin;
11	admin	$argon2i$v=19$m=4096,t=3,p=1$YtVibcrZNOf5RssMw0AecA$Uptf9O5REv3ndB6KpJyIpEb+Pjyvk7SePEzGBrukjn4	admin@test.com
12	malcolm	$argon2i$v=19$m=4096,t=3,p=1$mGoRIMiVHu/I24jj0nJang$53fvmjeH5d3O0mHUhDSdbo1kVG8+gZR1/CNWwmKH3FA	malcolm@test.com
\.


--
-- TOC entry 3086 (class 0 OID 17113)
-- Dependencies: 215
-- Data for Name: user_role; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_role (user_id, role_id) FROM stdin;
11	3
12	1
\.


--
-- TOC entry 3100 (class 0 OID 0)
-- Dependencies: 213
-- Name: authority_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.authority_id_seq', 3, true);


--
-- TOC entry 3101 (class 0 OID 0)
-- Dependencies: 209
-- Name: contact_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.contact_id_seq', 50, true);


--
-- TOC entry 3102 (class 0 OID 0)
-- Dependencies: 205
-- Name: department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.department_id_seq', 1, true);


--
-- TOC entry 3103 (class 0 OID 0)
-- Dependencies: 203
-- Name: employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.employee_id_seq', 52, true);


--
-- TOC entry 3104 (class 0 OID 0)
-- Dependencies: 207
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.role_id_seq', 1, true);


--
-- TOC entry 3105 (class 0 OID 0)
-- Dependencies: 211
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.user_id_seq', 19, true);


--
-- TOC entry 2936 (class 2606 OID 17112)
-- Name: role authority_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT authority_name_key UNIQUE (name);


--
-- TOC entry 2938 (class 2606 OID 17110)
-- Name: role authority_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT authority_pkey PRIMARY KEY (id);


--
-- TOC entry 2930 (class 2606 OID 16728)
-- Name: contact contact_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contact
    ADD CONSTRAINT contact_pkey PRIMARY KEY (id);


--
-- TOC entry 2926 (class 2606 OID 16599)
-- Name: department department_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT department_pkey PRIMARY KEY (id);


--
-- TOC entry 2922 (class 2606 OID 16587)
-- Name: employee employee_contact_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_contact_id_key UNIQUE (contact_id);


--
-- TOC entry 2924 (class 2606 OID 16448)
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (id);


--
-- TOC entry 2928 (class 2606 OID 16610)
-- Name: job role_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);


--
-- TOC entry 2932 (class 2606 OID 17100)
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- TOC entry 2940 (class 2606 OID 17117)
-- Name: user_role user_role_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_role
    ADD CONSTRAINT user_role_pkey PRIMARY KEY (user_id, role_id);


--
-- TOC entry 2934 (class 2606 OID 17102)
-- Name: user user_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_username_key UNIQUE (username);


--
-- TOC entry 2944 (class 2606 OID 16734)
-- Name: employee employee_contact_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_contact_id_fkey FOREIGN KEY (contact_id) REFERENCES public.contact(id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 2942 (class 2606 OID 16611)
-- Name: employee employee_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.department(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 2941 (class 2606 OID 16454)
-- Name: employee employee_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES public.employee(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 2943 (class 2606 OID 16616)
-- Name: employee employee_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_role_id_fkey FOREIGN KEY (job_id) REFERENCES public.job(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 2945 (class 2606 OID 17123)
-- Name: user_role user_role_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_role
    ADD CONSTRAINT user_role_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.role(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2946 (class 2606 OID 17118)
-- Name: user_role user_role_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_role
    ADD CONSTRAINT user_role_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2021-06-02 21:51:21 UTC

--
-- PostgreSQL database dump complete
--

