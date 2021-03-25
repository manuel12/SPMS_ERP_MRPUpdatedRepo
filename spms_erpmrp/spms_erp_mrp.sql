CREATE TABLE public.employee
(
    id integer NOT NULL,
    contact_id integer NOT NULL,
    department_id integer NOT NULL,
    role_id integer NOT NULL,
    manager_id integer,
    CONSTRAINT employee_pkey PRIMARY KEY (id),
    CONSTRAINT employee_contact_id_key UNIQUE (contact_id),
    CONSTRAINT employee_contact_id_fkey FOREIGN KEY (contact_id)
    CONSTRAINT employee_contact_id_fkey FOREIGN KEY (contact_id)
        REFERENCES public.contact (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        NOT VALID,
    CONSTRAINT employee_department_id_fkey FOREIGN KEY (department_id)
        REFERENCES public.department (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        NOT VALID,
    CONSTRAINT employee_manager_id_fkey FOREIGN KEY (manager_id)
        REFERENCES public.employee (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    CONSTRAINT employee_role_id_fkey FOREIGN KEY (role_id)
        REFERENCES public.role (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE public.employee
    OWNER to spms_erp;

CREATE TABLE public.contact
(
    id serial NOT NULL,
    firstname character varying(40) COLLATE pg_catalog."default" NOT NULL,
    lastname character varying(40) COLLATE pg_catalog."default" NOT NULL,
    phone character varying(30) COLLATE pg_catalog."default",
    cell character varying(30) COLLATE pg_catalog."default",
    email email COLLATE pg_catalog."default",
    department character varying(40) COLLATE pg_catalog."default",
    role character varying(40) COLLATE pg_catalog."default",
    dob date,
    photo bytea,
    notes text COLLATE pg_catalog."default",
    CONSTRAINT contact_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE public.contact
    OWNER to spms_erp;

CREATE TABLE public.department
(
    id serial NOT NULL,
    name character varying(40) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT department_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE public.department
    OWNER to spms_erp;

CREATE TABLE public.role
(
    id serial NOT NULL,
    name character varying(40) COLLATE pg_catalog."default" NOT NULL,
    job_description bytea,
    CONSTRAINT role_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE public.role
    OWNER to spms_erp;

CREATE OR REPLACE VIEW public.employee_all_view
 AS
 SELECT employee.id,
    employee.contact_id,
    employee.department_id,
    employee.role_id,
    employee.manager_id,
    contact.firstname,
    contact.lastname,
    contact.phone,
    contact.cell,
    contact.email,
    contact.dob,
    contact.notes,
    department.name AS department_name,
    role.name AS role_name
   FROM employee
     LEFT JOIN contact ON employee.contact_id = contact.id
     LEFT JOIN department ON employee.department_id = department.id
     LEFT JOIN role ON employee.role_id = role.id;

ALTER TABLE public.employee_all_view
    OWNER TO spms_erp;

CREATE OR REPLACE PROCEDURE public.create_employee(
	_firstname character varying,
	_lastname character varying,
	_phone character varying,
	_cell character varying,
	_email email,
	_dob date,
	_photo bytea,
	_notes text,
	_department_id integer,
	_role_id integer,
	_manager_id integer,
	INOUT ret_contact_id integer,
	INOUT ret_employee_id integer)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN

INSERT INTO contact (firstname, lastname, phone, cell, email, dob, photo, notes) VALUES (_firstname, _lastname, _phone, _cell, _email, _dob, _photo, _notes) RETURNING contact.id INTO ret_contact_id;
INSERT INTO employee (contact_id, department_id, role_id, manager_id) VALUES (ret_contact_id, _department_id, _role_id, _manager_id) RETURNING employee.id INTO ret_employee_id;

COMMIT;
END;
$BODY$;

CREATE OR REPLACE PROCEDURE public.update_employee(
	_firstname character varying,
	_lastname character varying,
	_phone character varying,
	_cell character varying,
	_email email,
	_dob date,
	_photo bytea,
	_notes text,
	_department_id integer,
	_role_id integer,
	_manager_id integer,
	_contact_id integer,
	INOUT _employee_id integer)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN

UPDATE contact SET (firstname, lastname, phone, cell, email, dob, photo, notes) = (_firstname, _lastname, _phone, _cell, _email, _dob, _photo, _notes) WHERE id = _contact_id;
UPDATE employee SET (department_id, role_id, manager_id) = (_department_id, _role_id, _manager_id) WHERE id = _employee_id RETURNING id INTO _employee_id;

COMMIT;
END;
$BODY$;

CREATE TYPE gender AS ENUM('M', 'F');

CREATE TABLE employees (
    emp_no      INT             NOT NULL,
    birth_date  DATE            NOT NULL,
    first_name  VARCHAR(14)     NOT NULL,
    last_name   VARCHAR(16)     NOT NULL,
    gender      gender 		NULL,    
    hire_date   DATE            NOT NULL,
    PRIMARY KEY (emp_no)
);

CREATE TABLE departments (
    dept_no     CHAR(4)         NOT NULL,
    dept_name   VARCHAR(40)     NOT NULL,
    PRIMARY KEY (dept_no),
    UNIQUE   	(dept_name)
);

CREATE TABLE dept_manager (
   dept_no      CHAR(4)         NOT NULL,
   emp_no       INT             NOT NULL,
   from_date    DATE            NOT NULL,
   to_date      DATE            NOT NULL,
   FOREIGN KEY (emp_no)  REFERENCES employees (emp_no)    ON DELETE CASCADE,
   FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
   PRIMARY KEY (emp_no,dept_no)
); 

CREATE INDEX dept_manager_dept_no_idx ON dept_manager(dept_no);

CREATE TABLE dept_emp (
    emp_no      INT             NOT NULL,
    dept_no     CHAR(4)         NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no)  REFERENCES employees   (emp_no)  ON DELETE CASCADE,
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,dept_no)
);

CREATE INDEX dept_emp_dept_no_idx ON dept_emp(dept_no);

CREATE TABLE titles (
    emp_no      INT             NOT NULL,
    title       VARCHAR(50)     NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,title, from_date)
); 


CREATE TABLE salaries (
    emp_no      INT             NOT NULL,
    salary      INT             NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no, from_date)
); 

\echo 'LOADING departments'
\i load_departments.sql 
\echo 'LOADING employees'
\i load_employees.sql 
\echo 'LOADING dept_emp'
\i load_dept_emp.sql 
\echo 'LOADING dept_manager'
\i load_dept_manager.sql 
\echo 'LOADING titles'
\i load_titles.sql 
\echo 'LOADING salaries'
\i load_salaries.sql 

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: employees; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA employees;


SET search_path = employees, pg_catalog;

--
-- Name: employee_gender; Type: TYPE; Schema: employees; Owner: -
--

CREATE TYPE employee_gender AS ENUM (
    'M',
    'F'
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: department; Type: TABLE; Schema: employees; Owner: -
--

CREATE TABLE department (
    id character(4) NOT NULL,
    dept_name character varying(40) NOT NULL
);


--
-- Name: department_employee; Type: TABLE; Schema: employees; Owner: -
--

CREATE TABLE department_employee (
    employee_id bigint NOT NULL,
    department_id character(4) NOT NULL,
    from_date date NOT NULL,
    to_date date NOT NULL
);


--
-- Name: department_manager; Type: TABLE; Schema: employees; Owner: -
--

CREATE TABLE department_manager (
    employee_id bigint NOT NULL,
    department_id character(4) NOT NULL,
    from_date date NOT NULL,
    to_date date NOT NULL
);


--
-- Name: employee; Type: TABLE; Schema: employees; Owner: -
--

CREATE TABLE employee (
    id bigint NOT NULL,
    birth_date date NOT NULL,
    first_name character varying(14) NOT NULL,
    last_name character varying(16) NOT NULL,
    gender employee_gender NOT NULL,
    hire_date date NOT NULL
);


--
-- Name: id_employee_seq; Type: SEQUENCE; Schema: employees; Owner: -
--

CREATE SEQUENCE id_employee_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: id_employee_seq; Type: SEQUENCE OWNED BY; Schema: employees; Owner: -
--

ALTER SEQUENCE id_employee_seq OWNED BY employee.id;


--
-- Name: salary; Type: TABLE; Schema: employees; Owner: -
--

CREATE TABLE salary (
    employee_id bigint NOT NULL,
    amount bigint NOT NULL,
    from_date date NOT NULL,
    to_date date NOT NULL
);


--
-- Name: title; Type: TABLE; Schema: employees; Owner: -
--

CREATE TABLE title (
    employee_id bigint NOT NULL,
    title character varying(50) NOT NULL,
    from_date date NOT NULL,
    to_date date
);


--
-- Name: id; Type: DEFAULT; Schema: employees; Owner: -
--

ALTER TABLE ONLY employee ALTER COLUMN id SET DEFAULT nextval('id_employee_seq'::regclass);


--
-- Name: idx_16979_primary; Type: CONSTRAINT; Schema: employees; Owner: -
--

ALTER TABLE ONLY department
    ADD CONSTRAINT idx_16979_primary PRIMARY KEY (id);


--
-- Name: idx_16982_primary; Type: CONSTRAINT; Schema: employees; Owner: -
--

ALTER TABLE ONLY department_employee
    ADD CONSTRAINT idx_16982_primary PRIMARY KEY (employee_id, department_id);


--
-- Name: idx_16985_primary; Type: CONSTRAINT; Schema: employees; Owner: -
--

ALTER TABLE ONLY department_manager
    ADD CONSTRAINT idx_16985_primary PRIMARY KEY (employee_id, department_id);


--
-- Name: idx_16988_primary; Type: CONSTRAINT; Schema: employees; Owner: -
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT idx_16988_primary PRIMARY KEY (id);


--
-- Name: idx_16991_primary; Type: CONSTRAINT; Schema: employees; Owner: -
--

ALTER TABLE ONLY salary
    ADD CONSTRAINT idx_16991_primary PRIMARY KEY (employee_id, from_date);


--
-- Name: idx_16994_primary; Type: CONSTRAINT; Schema: employees; Owner: -
--

ALTER TABLE ONLY title
    ADD CONSTRAINT idx_16994_primary PRIMARY KEY (employee_id, title, from_date);


--
-- Name: idx_16979_dept_name; Type: INDEX; Schema: employees; Owner: -
--

CREATE UNIQUE INDEX idx_16979_dept_name ON department USING btree (dept_name);


--
-- Name: idx_16982_dept_no; Type: INDEX; Schema: employees; Owner: -
--

CREATE INDEX idx_16982_dept_no ON department_employee USING btree (department_id);


--
-- Name: idx_16985_dept_no; Type: INDEX; Schema: employees; Owner: -
--

CREATE INDEX idx_16985_dept_no ON department_manager USING btree (department_id);


--
-- Name: dept_emp_ibfk_1; Type: FK CONSTRAINT; Schema: employees; Owner: -
--

ALTER TABLE ONLY department_employee
    ADD CONSTRAINT dept_emp_ibfk_1 FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: dept_emp_ibfk_2; Type: FK CONSTRAINT; Schema: employees; Owner: -
--

ALTER TABLE ONLY department_employee
    ADD CONSTRAINT dept_emp_ibfk_2 FOREIGN KEY (department_id) REFERENCES department(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: dept_manager_ibfk_1; Type: FK CONSTRAINT; Schema: employees; Owner: -
--

ALTER TABLE ONLY department_manager
    ADD CONSTRAINT dept_manager_ibfk_1 FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: dept_manager_ibfk_2; Type: FK CONSTRAINT; Schema: employees; Owner: -
--

ALTER TABLE ONLY department_manager
    ADD CONSTRAINT dept_manager_ibfk_2 FOREIGN KEY (department_id) REFERENCES department(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: salaries_ibfk_1; Type: FK CONSTRAINT; Schema: employees; Owner: -
--

ALTER TABLE ONLY salary
    ADD CONSTRAINT salaries_ibfk_1 FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: titles_ibfk_1; Type: FK CONSTRAINT; Schema: employees; Owner: -
--

ALTER TABLE ONLY title
    ADD CONSTRAINT titles_ibfk_1 FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE RESTRICT ON DELETE CASCADE;
    
DROP DATABASE IF EXISTS employees;
CREATE DATABASE IF NOT EXISTS employees;
USE employees;

SELECT 'CREATING DATABASE STRUCTURE' as 'INFO';

DROP TABLE IF EXISTS dept_emp,
                     dept_manager,
                     titles,
                     salaries, 
                     employees, 
                     departments;

/*!50503 set default_storage_engine = InnoDB */;
/*!50503 select CONCAT('storage engine: ', @@default_storage_engine) as INFO */;

CREATE TABLE employees (
    emp_no      INT             NOT NULL,
    birth_date  DATE            NOT NULL,
    first_name  VARCHAR(14)     NOT NULL,
    last_name   VARCHAR(16)     NOT NULL,
    gender      ENUM ('M','F')  NOT NULL,    
    hire_date   DATE            NOT NULL,
    PRIMARY KEY (emp_no)
);

CREATE TABLE departments (
    dept_no     CHAR(4)         NOT NULL,
    dept_name   VARCHAR(40)     NOT NULL,
    PRIMARY KEY (dept_no),
    UNIQUE  KEY (dept_name)
);

CREATE TABLE dept_manager (
   emp_no       INT             NOT NULL,
   dept_no      CHAR(4)         NOT NULL,
   from_date    DATE            NOT NULL,
   to_date      DATE            NOT NULL,
   FOREIGN KEY (emp_no)  REFERENCES employees (emp_no)    ON DELETE CASCADE,
   FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
   PRIMARY KEY (emp_no,dept_no)
); 

CREATE TABLE dept_emp (
    emp_no      INT             NOT NULL,
    dept_no     CHAR(4)         NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no)  REFERENCES employees   (emp_no)  ON DELETE CASCADE,
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,dept_no)
);

CREATE TABLE titles (
    emp_no      INT             NOT NULL,
    title       VARCHAR(50)     NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,title, from_date)
) 
; 

CREATE TABLE salaries (
    emp_no      INT             NOT NULL,
    salary      INT             NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no, from_date)
) 
; 

CREATE OR REPLACE VIEW dept_emp_latest_date AS
    SELECT emp_no, MAX(from_date) AS from_date, MAX(to_date) AS to_date
    FROM dept_emp
    GROUP BY emp_no;

# shows only the current department for each employee
CREATE OR REPLACE VIEW current_dept_emp AS
    SELECT l.emp_no, dept_no, l.from_date, l.to_date
    FROM dept_emp d
        INNER JOIN dept_emp_latest_date l
        ON d.emp_no=l.emp_no AND d.from_date=l.from_date AND l.to_date = d.to_date;

flush /*!50503 binary */ logs;

SELECT 'LOADING departments' as 'INFO';
source load_departments.dump ;
SELECT 'LOADING employees' as 'INFO';
source load_employees.dump ;
SELECT 'LOADING dept_emp' as 'INFO';
source load_dept_emp.dump ;
SELECT 'LOADING dept_manager' as 'INFO';
source load_dept_manager.dump ;
SELECT 'LOADING titles' as 'INFO';
source load_titles.dump ;
SELECT 'LOADING salaries' as 'INFO';
source load_salaries1.dump ;
source load_salaries2.dump ;
source load_salaries3.dump ;

source show_elapsed.sql ;
