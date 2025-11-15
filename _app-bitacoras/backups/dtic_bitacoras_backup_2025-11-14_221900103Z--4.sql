--
-- PostgreSQL database dump
--

\restrict cFYgHqr7l0QRJhLjpOKKHk9S4KslS85HUu2KD0bA2qOH0RiLRMLUafVJ0QoaueS

-- Dumped from database version 15.14
-- Dumped by pg_dump version 15.14

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
-- Name: dtic; Type: SCHEMA; Schema: -; Owner: dtic_user
--

CREATE SCHEMA dtic;


ALTER SCHEMA dtic OWNER TO dtic_user;

--
-- Name: generate_dtic_id(text); Type: FUNCTION; Schema: dtic; Owner: dtic_user
--

CREATE FUNCTION dtic.generate_dtic_id(prefix text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    counter INTEGER;
    new_id TEXT;
BEGIN
    -- Obtener el último contador para este prefijo
    SELECT COALESCE(MAX(CAST(SUBSTRING(dtic_id FROM LENGTH(prefix) + 2) AS INTEGER)), 0) + 1
    INTO counter
    FROM tecnicos
    WHERE dtic_id LIKE prefix || '-%';

    -- Generar nuevo ID
    new_id := prefix || '-' || LPAD(counter::TEXT, 4, '0');

    RETURN new_id;
END;
$$;


ALTER FUNCTION dtic.generate_dtic_id(prefix text) OWNER TO dtic_user;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: dtic; Owner: dtic_user
--

CREATE FUNCTION dtic.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION dtic.update_updated_at_column() OWNER TO dtic_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log; Type: TABLE; Schema: dtic; Owner: dtic_user
--

CREATE TABLE dtic.audit_log (
    id integer NOT NULL,
    user_id integer,
    action character varying(50) NOT NULL,
    entity_type character varying(50) NOT NULL,
    entity_id integer,
    old_values jsonb,
    new_values jsonb,
    ip_address inet,
    user_agent text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE dtic.audit_log OWNER TO dtic_user;

--
-- Name: TABLE audit_log; Type: COMMENT; Schema: dtic; Owner: dtic_user
--

COMMENT ON TABLE dtic.audit_log IS 'Registro de auditoría de todas las operaciones del sistema';


--
-- Name: audit_log_id_seq; Type: SEQUENCE; Schema: dtic; Owner: dtic_user
--

CREATE SEQUENCE dtic.audit_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dtic.audit_log_id_seq OWNER TO dtic_user;

--
-- Name: audit_log_id_seq; Type: SEQUENCE OWNED BY; Schema: dtic; Owner: dtic_user
--

ALTER SEQUENCE dtic.audit_log_id_seq OWNED BY dtic.audit_log.id;


--
-- Name: recurso_asignaciones; Type: TABLE; Schema: dtic; Owner: dtic_user
--

CREATE TABLE dtic.recurso_asignaciones (
    id integer NOT NULL,
    recurso_id integer NOT NULL,
    user_id integer NOT NULL,
    assigned_by integer,
    assigned_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    unassigned_by integer,
    unassigned_at timestamp with time zone,
    activo boolean DEFAULT true
);


ALTER TABLE dtic.recurso_asignaciones OWNER TO dtic_user;

--
-- Name: recurso_asignaciones_id_seq; Type: SEQUENCE; Schema: dtic; Owner: dtic_user
--

CREATE SEQUENCE dtic.recurso_asignaciones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dtic.recurso_asignaciones_id_seq OWNER TO dtic_user;

--
-- Name: recurso_asignaciones_id_seq; Type: SEQUENCE OWNED BY; Schema: dtic; Owner: dtic_user
--

ALTER SEQUENCE dtic.recurso_asignaciones_id_seq OWNED BY dtic.recurso_asignaciones.id;


--
-- Name: recurso_historial; Type: TABLE; Schema: dtic; Owner: dtic_user
--

CREATE TABLE dtic.recurso_historial (
    id integer NOT NULL,
    recurso_id integer NOT NULL,
    action character varying(50) NOT NULL,
    usuario_id integer,
    tecnico_id integer,
    details text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE dtic.recurso_historial OWNER TO dtic_user;

--
-- Name: recurso_historial_id_seq; Type: SEQUENCE; Schema: dtic; Owner: dtic_user
--

CREATE SEQUENCE dtic.recurso_historial_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dtic.recurso_historial_id_seq OWNER TO dtic_user;

--
-- Name: recurso_historial_id_seq; Type: SEQUENCE OWNED BY; Schema: dtic; Owner: dtic_user
--

ALTER SEQUENCE dtic.recurso_historial_id_seq OWNED BY dtic.recurso_historial.id;


--
-- Name: recursos; Type: TABLE; Schema: dtic; Owner: dtic_user
--

CREATE TABLE dtic.recursos (
    id integer NOT NULL,
    dtic_id character varying(20) NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    category character varying(50) NOT NULL,
    status character varying(20) DEFAULT 'available'::character varying,
    location character varying(200),
    technical_specs jsonb,
    serial_number character varying(100),
    model character varying(100),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT recursos_category_check CHECK (((category)::text = ANY (ARRAY[('hardware'::character varying)::text, ('software'::character varying)::text, ('network'::character varying)::text, ('security'::character varying)::text, ('tools'::character varying)::text, ('facilities'::character varying)::text]))),
    CONSTRAINT recursos_status_check CHECK (((status)::text = ANY (ARRAY[('available'::character varying)::text, ('assigned'::character varying)::text, ('maintenance'::character varying)::text, ('retired'::character varying)::text])))
);


ALTER TABLE dtic.recursos OWNER TO dtic_user;

--
-- Name: recursos_id_seq; Type: SEQUENCE; Schema: dtic; Owner: dtic_user
--

CREATE SEQUENCE dtic.recursos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dtic.recursos_id_seq OWNER TO dtic_user;

--
-- Name: recursos_id_seq; Type: SEQUENCE OWNED BY; Schema: dtic; Owner: dtic_user
--

ALTER SEQUENCE dtic.recursos_id_seq OWNED BY dtic.recursos.id;


--
-- Name: tarea_recursos; Type: TABLE; Schema: dtic; Owner: dtic_user
--

CREATE TABLE dtic.tarea_recursos (
    id integer NOT NULL,
    tarea_id integer NOT NULL,
    recurso_id integer NOT NULL,
    assigned_by integer,
    assigned_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    unassigned_by integer,
    unassigned_at timestamp with time zone,
    activo boolean DEFAULT true,
    estimated_hours numeric(5,2),
    actual_hours numeric(5,2),
    notes text
);


ALTER TABLE dtic.tarea_recursos OWNER TO dtic_user;

--
-- Name: tarea_recursos_id_seq; Type: SEQUENCE; Schema: dtic; Owner: dtic_user
--

CREATE SEQUENCE dtic.tarea_recursos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dtic.tarea_recursos_id_seq OWNER TO dtic_user;

--
-- Name: tarea_recursos_id_seq; Type: SEQUENCE OWNED BY; Schema: dtic; Owner: dtic_user
--

ALTER SEQUENCE dtic.tarea_recursos_id_seq OWNED BY dtic.tarea_recursos.id;


--
-- Name: tareas; Type: TABLE; Schema: dtic; Owner: dtic_user
--

CREATE TABLE dtic.tareas (
    id integer NOT NULL,
    dtic_id character varying(20) NOT NULL,
    title character varying(200) NOT NULL,
    description text,
    technician_id integer,
    status character varying(20) DEFAULT 'pending'::character varying,
    priority character varying(10) DEFAULT 'medium'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    due_date timestamp with time zone,
    completed_at timestamp with time zone,
    CONSTRAINT tareas_priority_check CHECK (((priority)::text = ANY (ARRAY[('low'::character varying)::text, ('medium'::character varying)::text, ('high'::character varying)::text, ('urgent'::character varying)::text]))),
    CONSTRAINT tareas_status_check CHECK (((status)::text = ANY (ARRAY[('pending'::character varying)::text, ('in_progress'::character varying)::text, ('completed'::character varying)::text, ('cancelled'::character varying)::text])))
);


ALTER TABLE dtic.tareas OWNER TO dtic_user;

--
-- Name: TABLE tareas; Type: COMMENT; Schema: dtic; Owner: dtic_user
--

COMMENT ON TABLE dtic.tareas IS 'Tabla de tareas asignadas a técnicos';


--
-- Name: tareas_id_seq; Type: SEQUENCE; Schema: dtic; Owner: dtic_user
--

CREATE SEQUENCE dtic.tareas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dtic.tareas_id_seq OWNER TO dtic_user;

--
-- Name: tareas_id_seq; Type: SEQUENCE OWNED BY; Schema: dtic; Owner: dtic_user
--

ALTER SEQUENCE dtic.tareas_id_seq OWNED BY dtic.tareas.id;


--
-- Name: tecnicos; Type: TABLE; Schema: dtic; Owner: dtic_user
--

CREATE TABLE dtic.tecnicos (
    id integer NOT NULL,
    dtic_id character varying(20) NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    phone character varying(20),
    department character varying(100) NOT NULL,
    role character varying(20) NOT NULL,
    password_hash character varying(255),
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT tecnicos_role_check CHECK (((role)::text = ANY (ARRAY[('admin'::character varying)::text, ('technician'::character varying)::text, ('viewer'::character varying)::text])))
);


ALTER TABLE dtic.tecnicos OWNER TO dtic_user;

--
-- Name: TABLE tecnicos; Type: COMMENT; Schema: dtic; Owner: dtic_user
--

COMMENT ON TABLE dtic.tecnicos IS 'Tabla principal de técnicos del sistema DTIC Bitácoras';


--
-- Name: tecnicos_id_seq; Type: SEQUENCE; Schema: dtic; Owner: dtic_user
--

CREATE SEQUENCE dtic.tecnicos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dtic.tecnicos_id_seq OWNER TO dtic_user;

--
-- Name: tecnicos_id_seq; Type: SEQUENCE OWNED BY; Schema: dtic; Owner: dtic_user
--

ALTER SEQUENCE dtic.tecnicos_id_seq OWNED BY dtic.tecnicos.id;


--
-- Name: usuarios_relacionados; Type: TABLE; Schema: dtic; Owner: dtic_user
--

CREATE TABLE dtic.usuarios_relacionados (
    id integer NOT NULL,
    dtic_id character varying(20) NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    email character varying(100),
    phone character varying(20),
    department character varying(100),
    "position" character varying(100),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE dtic.usuarios_relacionados OWNER TO dtic_user;

--
-- Name: usuarios_asignados_id_seq; Type: SEQUENCE; Schema: dtic; Owner: dtic_user
--

CREATE SEQUENCE dtic.usuarios_asignados_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dtic.usuarios_asignados_id_seq OWNER TO dtic_user;

--
-- Name: usuarios_asignados_id_seq; Type: SEQUENCE OWNED BY; Schema: dtic; Owner: dtic_user
--

ALTER SEQUENCE dtic.usuarios_asignados_id_seq OWNED BY dtic.usuarios_relacionados.id;


--
-- Name: audit_log id; Type: DEFAULT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.audit_log ALTER COLUMN id SET DEFAULT nextval('dtic.audit_log_id_seq'::regclass);


--
-- Name: recurso_asignaciones id; Type: DEFAULT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.recurso_asignaciones ALTER COLUMN id SET DEFAULT nextval('dtic.recurso_asignaciones_id_seq'::regclass);


--
-- Name: recurso_historial id; Type: DEFAULT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.recurso_historial ALTER COLUMN id SET DEFAULT nextval('dtic.recurso_historial_id_seq'::regclass);


--
-- Name: recursos id; Type: DEFAULT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.recursos ALTER COLUMN id SET DEFAULT nextval('dtic.recursos_id_seq'::regclass);


--
-- Name: tarea_recursos id; Type: DEFAULT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.tarea_recursos ALTER COLUMN id SET DEFAULT nextval('dtic.tarea_recursos_id_seq'::regclass);


--
-- Name: tareas id; Type: DEFAULT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.tareas ALTER COLUMN id SET DEFAULT nextval('dtic.tareas_id_seq'::regclass);


--
-- Name: tecnicos id; Type: DEFAULT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.tecnicos ALTER COLUMN id SET DEFAULT nextval('dtic.tecnicos_id_seq'::regclass);


--
-- Name: usuarios_relacionados id; Type: DEFAULT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.usuarios_relacionados ALTER COLUMN id SET DEFAULT nextval('dtic.usuarios_asignados_id_seq'::regclass);


--
-- Data for Name: audit_log; Type: TABLE DATA; Schema: dtic; Owner: dtic_user
--

COPY dtic.audit_log (id, user_id, action, entity_type, entity_id, old_values, new_values, ip_address, user_agent, created_at) FROM stdin;
\.


--
-- Data for Name: recurso_asignaciones; Type: TABLE DATA; Schema: dtic; Owner: dtic_user
--

COPY dtic.recurso_asignaciones (id, recurso_id, user_id, assigned_by, assigned_at, unassigned_by, unassigned_at, activo) FROM stdin;
1	2	1	1	2025-11-01 21:09:56.362271+00	\N	\N	t
2	6	3	2	2025-11-01 21:09:56.362271+00	\N	\N	t
3	8	6	1	2025-11-04 21:20:33.13337+00	\N	\N	t
\.


--
-- Data for Name: recurso_historial; Type: TABLE DATA; Schema: dtic; Owner: dtic_user
--

COPY dtic.recurso_historial (id, recurso_id, action, usuario_id, tecnico_id, details, created_at) FROM stdin;
\.


--
-- Data for Name: recursos; Type: TABLE DATA; Schema: dtic; Owner: dtic_user
--

COPY dtic.recursos (id, dtic_id, name, description, category, status, location, technical_specs, serial_number, model, created_at, updated_at) FROM stdin;
1	REC-0001	Laptop Dell Latitude 5420	Laptop para trabajo administrativo	hardware	available	Oficina Principal	{"cpu": "Intel i5", "ram": "16GB", "storage": "512GB SSD"}	DL5420-2025-001	Dell Latitude 5420	2025-11-01 21:09:56.358911+00	2025-11-01 21:09:56.358911+00
2	REC-0002	Proyector Epson EB-S41	Proyector para presentaciones	hardware	assigned	Sala de Reuniones	{"brightness": "3200 lumens", "resolution": "SVGA"}	EP-S41-2025-002	Epson EB-S41	2025-11-01 21:09:56.358911+00	2025-11-01 21:09:56.358911+00
3	REC-0003	Antivirus Bitdefender Total Security	Licencia corporativa de antivirus	software	available	\N	{"licenses": 25, "valid_until": "2025-12-15"}	BD-TS-2025-003	Bitdefender Total Security	2025-11-01 21:09:56.358911+00	2025-11-01 21:09:56.358911+00
4	REC-0004	Router Cisco RV340	Router para red corporativa	network	maintenance	Sala de Servidores	{"wifi": "Dual Band", "ports": "16 Gigabit"}	CS-RV340-2025-004	Cisco RV340	2025-11-01 21:09:56.358911+00	2025-11-01 21:09:56.358911+00
5	REC-0005	Kit de Herramientas de Red	Herramientas para mantenimiento de red	tools	available	Depósito Técnico	{"items": ["Tester", "Cables", "Conectores"]}	KT-RD-2025-005	Kit Herramientas Red	2025-11-01 21:09:56.358911+00	2025-11-01 21:09:56.358911+00
6	REC-0006	Licencia Windows Server 2022	Licencia para servidor principal	software	assigned	Sala de Servidores	{"cores": 16, "edition": "Standard"}	WS2022-STD-006	Windows Server 2022	2025-11-01 21:09:56.358911+00	2025-11-01 21:09:56.358911+00
8	REC-0007	srvv-KOHA	Servidor KOHA - Sistema de gestión bibliotecaria	hardware	available	Servidor Principal	\N	\N	Servidor Dedicado	2025-11-04 21:19:53.245336+00	2025-11-04 21:19:53.245336+00
139	AP001	ap-GOB-02	GOB-PasilloAp 2 en Gobierno; SN: F3608;	network	available	GOB	{}	F3608	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
140	AP002	ap-ICI-01	ICI-Pasillo	network	available	ICI	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
141	AP003	ap-ICI-02	ICI-Pasillo	network	available	ICI	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
142	AP004	ap-AUD-01	ICI-AuditorioSN: 3451;	network	available	ICI	{}	3451	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
143	AP005	ap-TIC-01	TIC-PasilloSN: F3605;	network	available	TIC	{}	F3605	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
144	AP006	ap-TIC-02	TIC-PasilloSN: F3606;	network	available	TIC	{}	F3606	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
145	AP007	ap-DAS-01	DAS-DASUTeNSN: F3600;	network	available	DAS	{}	F3600	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
146	AP008	ap-GOB-01	GOB-Pasillo	network	available	GOB	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
147	AP010	ap-EnGenius [??]	LABs-GAIA	network	available	LABs	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
148	AP011	ap-CANT-01	OCT-CantinaSN: F3598;	network	available	OCT	{}	F3598	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
149	AP012	ap-CANT-02	OCT-CantinaSN: F3602;	network	available	OCT	{}	F3602	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
150	AP013	ap-CANT-03	OCT-CantinaSN: F3599;	network	available	OCT	{}	F3599	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
151	AP014	ap-IEL-01	IEL-Pasillo	network	available	IEL	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
152	AP015	ap-IEL-02	IEL-PasilloSN: 3453;	network	available	IEL	{}	3453	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
153	AP016	ap-IEL-03	LAB-PasilloSN: F3597;	network	available	LAB	{}	F3597	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
154	AP017	ap-IEL-04	LAB-PasilloSN: F3607;	network	available	LAB	{}	F3607	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
155	AP018	ap-IEM-01	IEM-PasilloSN: F3609;	network	available	IEM	{}	F3609	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
156	AP019	ap-IEM-02	IEM-PasilloSN: F3610;	network	available	IEM	{}	F3610	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
157	AP020	ap-IEM-03	IEM-PasilloSN: F3611;	network	available	IEM	{}	F3611	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
158	AP021	ap-IEM-04	IEM-PasilloSN: F3603;	network	available	IEM	{}	F3603	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
159	CAM001	cam-KAPTIVO-01	IEL-PasilloMODELO: MLNPNX;	security	available	IEL	{}	\N	MLNPNX	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
160	CEL001	cel-GGONZALEZ	GOB-SecACADUSR: Germán GONZALEZ;	security	assigned	GOB	{"usr": "Germán GONZALEZ"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
161	DSP001	dsp-FFPrint	OCT-GuardiaFinger Face Printt;	hardware	available	OCT	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
162	DVR001	dvr-CamsGuardia	OCT-RRHHDVR Cámaras Guardias;	hardware	available	OCT	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
163	IMP002	imp-HP-01	TIC-BibliotecaHP LASER MFP 137fnw;	hardware	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
164	IMP003	imp-HP-02	OCT-DepBASUSR: Agostina CHAVEZ; MOD: P2055 DN;	hardware	assigned	OCT	{"usr": "Agostina CHAVEZ"}	\N	P2055 DN	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
165	IMP004	imp-HP-03	DAS-DASUTeNMOD: SMART TANK 515;	hardware	available	DAS	{}	\N	SMART TANK 515	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
166	IMP005	imp-HP-04	GOB-SecEXTUSR: Karina LOTO; MOD: SMART TANK 515;	hardware	assigned	GOB	{"usr": "Karina LOTO"}	\N	SMART TANK 515	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
167	IMP006	imp-HP-05	GOB-DecanatoMOD: SMART TANK 533;	hardware	available	GOB	{}	\N	SMART TANK 533	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
168	IMP007	imp-RICOH-02	OCT-POSGUSR: Karina SALDIS, RICOH Aficio MP 301;	hardware	assigned	OCT	{"usr": "Karina SALDIS, RICOH Aficio MP 301"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
169	IMP008	imp-RICOH-03	GOB-SecACADRICOH IM 430;	hardware	available	GOB	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
170	IMP009	imp-RICOH-04	OCT-CentroEstudiantesMOD: MP 501;	hardware	available	OCT	{}	\N	MP 501	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
171	IMP010	imp-RICOH-05	TIC-DTICMOD: SP3710DN;	hardware	available	TIC	{}	\N	SP3710DN	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
172	IMP011	imp-RICOH-01	TIC-TítulosRICOH SP377, USR: Araceli ZALAZAR;	hardware	assigned	TIC	{"usr": "Araceli ZALAZAR"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
173	IMP012	imp-SAMSUNG-01	OCT-PSICOUSR: Luciana TOLEDO; MOD: ML 2850;	hardware	assigned	OCT	{"usr": "Luciana TOLEDO"}	\N	ML 2850	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
174	IMP013	imp-LANIER-01	OCT-SSAEUSR: Ignacio MARTINEZ; MOD: MP402;	hardware	assigned	OCT	{"usr": "Ignacio MARTINEZ"}	\N	MP402	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
175	IMP014	imp-HP-06	GOB-SecPLANUSR: Oscar GALLARDO; MOD: LJPro-MFP_M130Fw;	hardware	assigned	GOB	{"usr": "Oscar GALLARDO"}	\N	LJPro-MFP_M130Fw	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
176	IMP015	imp-HP-07	GOB-MesaENTRADAHP-LaserJet-Pro-MFP-M426fdw;	hardware	available	GOB	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
177	NETB001	netb-UTNLR-NETB01	TIC-DTIC	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
178	NOT002	not-AZALAZAR	TIC-TítulosUSR: Araceli ZALAZAR;	hardware	assigned	TIC	{"usr": "Araceli ZALAZAR"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
179	NOT003	not-CGATICA	TIC-DTIC	hardware	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
180	NOT004	not-ELUCERO	OCT-DepIELUSR: Emilce LUCERO;	hardware	assigned	OCT	{"usr": "Emilce LUCERO"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
181	NOT005	not-FRUSSO	OCT-DepBASUSR: Federico RUSSO;	hardware	assigned	OCT	{"usr": "Federico RUSSO"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
182	NOT006	not-GSOTOMAYOR	OCT-DepIELUSR: Germán SOTOMAYOR;	hardware	assigned	OCT	{"usr": "Germán SOTOMAYOR"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
183	NOT007	not-HWHITAKER	OCT-POSGUSR: Héctor WHITAKER;	hardware	assigned	OCT	{"usr": "Héctor WHITAKER"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
184	NOT008	not-JBRIZUELA	OCT-DepICIUSR: Juan BRIZUELA;	hardware	assigned	OCT	{"usr": "Juan BRIZUELA"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
185	NOT009	not-JNIETO	GOB-DecanatoUSR: Jose NIETO;	hardware	assigned	GOB	{"usr": "Jose NIETO"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
186	NOT010	not-JPAEZ	OCT-DepBASUSR: Juan PAEZ;	hardware	assigned	OCT	{"usr": "Juan PAEZ"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
187	NOT011	not-JPOLI	GOB-SecPLANUSR: Jose POLI;	hardware	assigned	GOB	{"usr": "Jose POLI"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
188	NOT012	not-MHEREDIA	OCT-DepIEMUSR: Martín HEREDIA;	hardware	assigned	OCT	{"usr": "Martín HEREDIA"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
189	NOT013	not-EVTos1	ICI-AuditorioHOST: UTNLR-TIC-NOT01;	hardware	available	ICI	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
190	NOT014	not-GGONZALEZ	GOB-SecACADUSR: Germán GONZALEZ;	hardware	assigned	GOB	{"usr": "Germán GONZALEZ"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
191	NOT015	not-DSOTOMAYOR	GOB-SecADMUSR: Denise SOTOMAYOR;	hardware	assigned	GOB	{"usr": "Denise SOTOMAYOR"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
192	NOT016	not-MLPALAZZI	GOB-SecACADUSR: Maria Luisa PALAZZI;	hardware	assigned	GOB	{"usr": "Maria Luisa PALAZZI"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
193	NOT017	not-FMONLA	ICI-AuditorioUSR: Franco MONLA;	hardware	assigned	ICI	{"usr": "Franco MONLA"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
194	NOT018	not-RMONLA	TIC-DTICUSR: Ricardo MONLA;	hardware	assigned	TIC	{"usr": "Ricardo MONLA"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
195	NOT019	not-SecExt-not-1	GOB-SecEXTUSR: Antonio ABDALA;	hardware	assigned	GOB	{"usr": "Antonio ABDALA"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
196	NOT020	not-VNIETO	OCT-DepIEMUSR: Víctor NIETO;	hardware	assigned	OCT	{"usr": "Víctor NIETO"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
197	NOT021	not-GGRACIA	OCT-DepIEMUSR: Germán GRACIA;	hardware	assigned	OCT	{"usr": "Germán GRACIA"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
198	NOT022	not-DSIMONE	DocenteUSR: Dante SIMONE;	hardware	assigned	\N	{"usr": "Dante SIMONE"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
199	NOT023	not-MMERCADO	DocenteUSR: Manuel MERCADO;	hardware	assigned	\N	{"usr": "Manuel MERCADO"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
200	NOT024	not-FMONLA	ICI-AuditorioUSR: Franco MONLA;	hardware	assigned	ICI	{"usr": "Franco MONLA"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
201	NOT025	not-JGRACIA	OCT-CarrATerminoUSR: Jorge GRACIA;	hardware	assigned	OCT	{"usr": "Jorge GRACIA"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
202	NOT026	not-Auditorio Expositor	ICI-Auditorio	hardware	available	ICI	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
203	NOT027	not-SREINOSOS	OCT-SeCyT\nUSR: Carlos SANCHEZ REINOSOS; HOST: DESKTOP-TIL47OO;	hardware	assigned	OCT	{"usr": "Carlos SANCHEZ REINOSOS"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
204	NOT028	not-JNIETO-not-	GOB-DecanatoUSR: José NIETO;	hardware	assigned	GOB	{"usr": "José NIETO"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
205	NOT029	not	ICI-GAIA	hardware	available	ICI	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
206	NOT030	not-UTNLR-NOT030	OCT-SeCyTUSR: Dr. Sanchez Reinozo; MODELO: BANGHO-MAX-L5;	hardware	assigned	OCT	{"usr": "Dr. Sanchez Reinozo"}	\N	BANGHO-MAX-L5	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
207	PC001	pc-UTNLR90	GOB-LEGOUSR: Celeste TOLEDO;	hardware	assigned	GOB	{"usr": "Celeste TOLEDO"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
208	PC002	pc-CenTEL	TIC-ServidoresCentral Telónica Digital;	hardware	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
209	PC003	pc-Centro Estudiantes	OCT-CentroEstudiantes	hardware	available	OCT	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
210	PC004	pc-FRLR1905	GOB-LEGOUSR: Verónica STEWART;	hardware	assigned	GOB	{"usr": "Verónica STEWART"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
211	PC005	pc-UTNLR68	ICI-AuditorioAudiTEMP;	hardware	available	ICI	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
212	PC006	pc-UTNLR69	GOB-SecCyTUSR: Laura CARRIZO;	hardware	assigned	GOB	{"usr": "Laura CARRIZO"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
213	PC007	pc-UTNLR01	GOB-SecADMUSR: Denise SOTOMAYOR;	hardware	assigned	GOB	{"usr": "Denise SOTOMAYOR"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
214	PC008	pc-UTNLR02	GOB-SecACADUSR: Germán GONZALEZ;	hardware	assigned	GOB	{"usr": "Germán GONZALEZ"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
215	PC009	pc-UTNLR03	OCT-RRHHUSR: Marcela LOPEZ;	hardware	assigned	OCT	{"usr": "Marcela LOPEZ"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
216	PC010	pc-UTNLR89	OCT-RRHHUSR: Marcela LOPEZ;	hardware	assigned	OCT	{"usr": "Marcela LOPEZ"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
217	PC011	pc-UTNLR06	GOB-PatrimonioUSR: Armando BARRIONUEVO;	hardware	assigned	GOB	{"usr": "Armando BARRIONUEVO"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
218	PC012	pc-UTNLR09	OCT-CarrATerminoUSR: Guillermo HERRERA;	hardware	assigned	OCT	{"usr": "Guillermo HERRERA"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
219	PC013	pc-UTNLR10	OCT-DepICIUSR: Juan BRIZUELA;	hardware	assigned	OCT	{"usr": "Juan BRIZUELA"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
220	PC014	pc-UTNLR11	GOB-MesaENTRADAUSR: UTNLR11;	hardware	assigned	GOB	{"usr": "UTNLR11"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
221	PC015	pc-UTNLR12	GOB-LEGOUSR: Ileana BANDERA;	hardware	assigned	GOB	{"usr": "Ileana BANDERA"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
222	PC016	pc-UTNLR13	GOB-MesaENTRADAUSR: Estefanía RUEDA;	hardware	assigned	GOB	{"usr": "Estefanía RUEDA"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
223	PC017	pc-UTNLR14	TIC-BibliotecaUSR: Mónica ALVAREZ;	hardware	assigned	TIC	{"usr": "Mónica ALVAREZ"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
224	PC018	pc-UTNLR15	TIC-BibliotecaUSR: Silvia ROMERO;	hardware	assigned	TIC	{"usr": "Silvia ROMERO"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
225	PC019	pc-UTNLR17	GOB-SecPLANUSR: Jose POLI;	hardware	assigned	GOB	{"usr": "Jose POLI"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
226	PC020	pc-UTNLR17	OCT-PSICOUSR: Flavia CACERES;	hardware	assigned	OCT	{"usr": "Flavia CACERES"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
227	PC021	pc-UTNLR18	OCT-PSICOUSR: Luciana TOLEDO;	hardware	assigned	OCT	{"usr": "Luciana TOLEDO"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
228	PC022	pc-UTNLR19	GOB-SecEXTUSR: Karina LOTO;	hardware	assigned	GOB	{"usr": "Karina LOTO"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
229	PC023	pc-UTNLR20	GOB-SecEXTUSR: Henry VEGA;	hardware	assigned	GOB	{"usr": "Henry VEGA"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
230	PC024	pc-UTNLR24	OCT-BedelíaUSR: Mirtha TORRES;	hardware	assigned	OCT	{"usr": "Mirtha TORRES"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
231	PC025	pc-UTNLR25	OCT-RRHHUSR: Florecia VAZQUEZ;	hardware	assigned	OCT	{"usr": "Florecia VAZQUEZ"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
232	PC026	pc-UTNLR28	OCT-SSAE	hardware	available	OCT	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
233	PC027	pc-UTNLR29	OCT-POSGUSR: Karina SALDIS;	hardware	assigned	OCT	{"usr": "Karina SALDIS"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
234	PC028	pc-UTNLR31	OCT-DepIEMUSR: Germán GRACIA;	hardware	assigned	OCT	{"usr": "Germán GRACIA"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
235	PC029	pc-UTNLR32	TIC-Biblioteca	hardware	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
236	PC030	pc-UTNLR33	OCT-DepBASUSR: Juan PAEZ;	hardware	assigned	OCT	{"usr": "Juan PAEZ"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
237	PC031	pc-UTNLR34	DAS-DASUTeNUSR: ALMIRON_y_MOLINA;	hardware	assigned	DAS	{"usr": "ALMIRON_y_MOLINA"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
238	PC032	pc-UTNLR36	OCT-DepIEM	hardware	available	OCT	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
239	PC033	pc-UTNLR37	TIC-TítulosUSR: Araceli ZALAZAR;	hardware	assigned	TIC	{"usr": "Araceli ZALAZAR"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
240	PC034	pc-UTNLR66	TIC-DTICUSR: Abel SALAZAR;	hardware	assigned	TIC	{"usr": "Abel SALAZAR"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
241	PC035	pc-UTNLR38	OCT-CarrATerminoUSR: Martín VERGARA;	hardware	assigned	OCT	{"usr": "Martín VERGARA"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
242	PC036	pc-UTNLR39	OCT-BedelíaUSR: Enzo VARGAS ??Buscar??;	hardware	assigned	OCT	{"usr": "Enzo VARGAS ??Buscar??"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
243	PC037	pc-UTNLR40	OCT-SSAEUSR: Ignacio MARTINEZ;	hardware	assigned	OCT	{"usr": "Ignacio MARTINEZ"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
244	PC038	pc-UTNLR41	GOB-SecEXTUSR: Karina LOTO;	hardware	assigned	GOB	{"usr": "Karina LOTO"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
245	PC039	pc-UTNLR42	OCT-DepBASUSR: Agostina CHAVEZ;	hardware	assigned	OCT	{"usr": "Agostina CHAVEZ"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
246	PC040	pc-UTNLR44	TIC-DTICUSR: Wilfredo KRUPP;	hardware	assigned	TIC	{"usr": "Wilfredo KRUPP"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
247	PC041	pc-UTNLR51	GOB-SecEXTUSR: Antonio ABDALA;	hardware	assigned	GOB	{"usr": "Antonio ABDALA"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
248	PC042	pc-UTNLR52	OCT-DepIEL	hardware	available	OCT	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
249	PC043	pc-UTNLR54	OCT-DepICI	hardware	available	OCT	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
250	PC044	pc-UTNLR55	OCT-DepIEMUSR: Víctor NIETO;	hardware	assigned	OCT	{"usr": "Víctor NIETO"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
251	PC045	pc-UTNLR56	GOB-FirmaDIGITALUSR: Carolina RUARTEZ;	hardware	assigned	GOB	{"usr": "Carolina RUARTEZ"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
252	PC046	pc-UTNLR57	TIC-DTICUSR: Cristian GATICA;	hardware	assigned	TIC	{"usr": "Cristian GATICA"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
253	PC047	pc-UTNLR58	OCT-DepIELUSR: Walter SOTOMAYOR;	hardware	assigned	OCT	{"usr": "Walter SOTOMAYOR"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
254	PC048	pc-LEGO	GOB-LEGOUSR: Verónica STEWART;	hardware	assigned	GOB	{"usr": "Verónica STEWART"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
255	PC049	pc-UTNLR60	OCT-DepBASUSR: Federico RUSSO;	hardware	assigned	OCT	{"usr": "Federico RUSSO"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
256	PC050	pc-UTNLR60?	LABs-Electrónica	hardware	available	LABs	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
257	PC051	pc-UTNLR61	LABs-Electrónica	hardware	available	LABs	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
258	PC052	pc-UTNLR62	LABs-Electrónica	hardware	available	LABs	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
259	PC053	pc-UTNLR63	LABs-Electrónica	hardware	available	LABs	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
260	PC054	pc-UTNLR64	DAS-DASUTeNHOST: pc-DASU0; AnyDesk: 1519388003;	hardware	available	DAS	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
261	PC055	pc-UTNLR65	LABs-Electrónica	hardware	available	LABs	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
262	PC056	pc-UTNLR67	GOB-DecanatoUSR: Carolina RUARTEZ;	hardware	assigned	GOB	{"usr": "Carolina RUARTEZ"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
263	PC057	pc-UTNLR73	GOB-SecEXTUSR: Leonardo PEROSIO; SN: F3680;	hardware	assigned	GOB	{"usr": "Leonardo PEROSIO"}	F3680	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
264	PC058	pc-UTNLR70	OCT-DepICIUSR: Juan BRIZUELA; SN: F3672;	hardware	assigned	OCT	{"usr": "Juan BRIZUELA"}	F3672	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
265	PC059	pc-UTNLR71	OCT-CarrATerminoUSR: Guillermo HERRERA; SN: F3687;	hardware	assigned	OCT	{"usr": "Guillermo HERRERA"}	F3687	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
266	PC060	pc-UTNLR75	OCT-BedelíaUSR: Sonia MOLINA;	hardware	assigned	OCT	{"usr": "Sonia MOLINA"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
267	PC061	pc-UTNLR76	OCT-CarrATerminoUSR: Guillermo HERRERA;	hardware	assigned	OCT	{"usr": "Guillermo HERRERA"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
268	PC062	pc-UTNLR74	GOB-LEGOUSR: Verónica STEWART;	hardware	assigned	GOB	{"usr": "Verónica STEWART"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
269	PC063	pc-UTNLR77	TIC-BibliotecaUSR: Jéssica SANCHEZ;	hardware	assigned	TIC	{"usr": "Jéssica SANCHEZ"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
270	PC064	pc-UTNLR78	OCT-SSAEMOD: DELL 32731;	hardware	available	OCT	{}	\N	DELL 32731	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
271	PC065	pc-UTNLR79	OCT-SSAEMOD: DELL 32732;	hardware	available	OCT	{}	\N	DELL 32732	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
272	PC066	pc-UTNLR80	OCT-SSAEMOD: DELL 32733;	hardware	available	OCT	{}	\N	DELL 32733	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
273	PC067	pc-UTNLR81	OCT-SSAEMOD: DELL 32734;	hardware	available	OCT	{}	\N	DELL 32734	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
274	PC068	pc-UTNLR85	TIC-DTICUSR: Roberto CANIZA;	hardware	assigned	TIC	{"usr": "Roberto CANIZA"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
275	PC069	pc-UTNLR82	GOB-MesaENTRADA	hardware	available	GOB	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
276	PC070	pc-UTNLR86	GOB-PasilloUSR: Karina MORENO;	hardware	assigned	GOB	{"usr": "Karina MORENO"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
277	PC071	pc-UTNLR88	LABs-GEMLaRUSR: Marcelo GOMEZ;	hardware	assigned	LABs	{"usr": "Marcelo GOMEZ"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
278	PC072	pc-UTNLR87	LABs-Serv.-GeneralesUSR: Pedro CASTRO;	hardware	assigned	LABs	{"usr": "Pedro CASTRO"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
279	PC073	pc-FRLR1521	ICI-GAIAUSR: Cecilia BALDO;	hardware	assigned	ICI	{"usr": "Cecilia BALDO"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
280	PC074	pc-UTNLR32732	GOB-SecADMUSR: Denise SOTOMAYOR;	hardware	assigned	GOB	{"usr": "Denise SOTOMAYOR"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
281	PC075	pc-UTNLR-F3679	OCT-BedelíaUSR: Enzo VARGAS;	hardware	assigned	OCT	{"usr": "Enzo VARGAS"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
282	PC076	pc-UTNLR91	OCT-POSGUSR: Karina SALDIS;	hardware	assigned	OCT	{"usr": "Karina SALDIS"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
283	PC078	pc-DCALDERON	GOB-FRELaRUSR: Daniel CALDERON;	hardware	assigned	GOB	{"usr": "Daniel CALDERON"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
284	PC079	pc-NuevaPC079		hardware	available	\N	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
285	PC080	pc-UTNLR92	GOB-SecADMUSR: Karina MORENO;	hardware	assigned	GOB	{"usr": "Karina MORENO"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
286	PC081	pc-UTNLR93	GOB-SecADMUSR: Ileana BANDERA;	hardware	assigned	GOB	{"usr": "Ileana BANDERA"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
287	PC082	pc-UTNLR94	GOB-SecADMUSR: Denise SOTOMAYOR;	hardware	assigned	GOB	{"usr": "Denise SOTOMAYOR"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
288	PC083	pc-UTNLR95	OCT-RRHHUSR: Florencia VAZQUEZ;	hardware	assigned	OCT	{"usr": "Florencia VAZQUEZ"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
289	PC084	pc-UTNLR96	OCT-RRHHUSR: Marcela LOPEZ;	hardware	assigned	OCT	{"usr": "Marcela LOPEZ"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
290	PC085	pc-UTNLR97	GOB-SecADMUSR: Armando BARRIONUEVO;	hardware	assigned	GOB	{"usr": "Armando BARRIONUEVO"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
291	PC086	pc-UTNLR98	GOB-SecPLANUSR: Martín HEREDIA, UTNID: 31599, Marca EXO;	hardware	assigned	GOB	{"usr": "Martín HEREDIA, UTNID: 31599, Marca EXO"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
292	PC087	pc-MOC1	OCT-SeCyTUSR: Carlos SANCHEZ REINOSOS;	hardware	assigned	OCT	{"usr": "Carlos SANCHEZ REINOSOS"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
293	PC088	pc-MOC2	OCT-SeCyTUSR: Carlos SANCHEZ REINOSOS;	hardware	assigned	OCT	{"usr": "Carlos SANCHEZ REINOSOS"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
294	PCV001	pcv-DTIC	TIC-Servidores-PMox1	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
295	PCV002	pcv-XenCenter	TIC-DTIC-NS7	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
296	PCV003	pcv-DTIC-RRHH	TIC-DTIC-VNS07b	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
297	PCV004	pcv-TestRED	TIC-Servidores-PMox1	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
298	PCV005	pcv-Serviio-WX	TIC-Servidores-PMox1	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
299	PCV006	pcv-DASU1	DAS-DASUTeNUSR: Andrea ALMIRON; HOST: UTNLR83;	software	assigned	DAS	{"usr": "Andrea ALMIRON"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
300	PCV007	pcv-DASU2	DAS-DASUTeNUSR: Romina MOLINA; HOST: UTNLR84;	software	assigned	DAS	{"usr": "Romina MOLINA"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
301	PCV008	pcv-MiniOS-0_w10	TIC-Servidores-PMox2	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
302	PCV009	pcv-DASU3	DAS-DASUTeNUSR: Eugenia RIVEROS; HOST: UTNLR84;	software	assigned	DAS	{"usr": "Eugenia RIVEROS"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
303	PCV010	pcv-UTNLR250729-B	TIC-DTIC-NS8	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
304	RUT001	rut-WF-ACAREDITACION	GOB-SecPLANUSR: Oscar GALLARDO;	network	assigned	GOB	{"usr": "Oscar GALLARDO"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
305	RUT002	rut-WF-GAIA	ICI-GAIARouter WF GAIA;	network	available	ICI	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
306	RUT003	rut-WF-CIDomóticaT	LABs-GAIAUSR: Marcelo GOMEZ;	network	assigned	LABs	{"usr": "Marcelo GOMEZ"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
307	RUT004	rut-WF-Centro Estudiantes	OCT-CentroEstudiantes	network	available	OCT	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
308	RUT005	rut-WF-ACREDI	TIC-DTIC	network	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
309	RUT006	rut-DHCP 8x TL WR741N	TIC-Servidores	network	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
310	RUT007	rut-MKT1	TIC-ServidoresRouter Mikrotic Nuevo;	network	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
311	RUT008	rut-ISPT-IPT-01	TIC-ServidoresDHCP 16x;	network	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
312	RUT009	rut-ISPT-IPT-02	TIC-Servidores	network	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
313	RUT010	rut-ISP-TECO-01	TIC-ServidoresRouter ISP de RECTORADO;	network	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
314	RUT011	rut-WF-Fagdut1	IEM-Pasillo	network	available	IEM	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
315	RUT012	rut-MKT0	TIC-DTICRouter Viejo, actualmente en desuso..;	network	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
316	SRV001	srv-NS7	TIC-DTICSistema  ServTec (GLPI);	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
317	SRV002	srv-NS8	TIC-DTICServidor de Gestión; USR: Ricardo MONLA;	software	assigned	TIC	{"usr": "Ricardo MONLA"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
318	SRV003	srv-NS1	TIC-DTIC	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
319	SRV004	srv-Central - Elastix	TIC-Servidores	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
320	SRV005	srv-LEONK	TIC-DTIC\nX: Antiguo servidor  de sistemas de gestión, Proximamente servidor DASUTEN.;	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
321	SRV006	srv-PMOX1	TIC-ServidoresServidor de Máquinas Virtales;	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
322	SRV007	srv-PMOX2	TIC-Servidores	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
323	SRV008	srv-XEN1	TIC-ServidoresServidor de VMs Citrix XENCenter.;	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
324	SRV009	srv-Xen2	TIC-Servidores	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
325	SRV010	srv-S2	TIC-DTIC-srvPMOX3	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
326	SRV011	srv-PMOX3	TIC-Servidores	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
327	SRVV001	srvv-MAURIK	TIC-Servidores-Xen2Servidor de Dominio (AD);	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
328	SRVV002	srvv-Deb11-Base	TIC-Servidores-PMox1	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
329	SRVV003	srvv-Koha	TIC-Servidores-PMox1	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
330	SRVV004	srvv-MySQL	TIC-Servidores-PMox1	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
331	SRVV005	srvv-Odoo	TIC-Servidores-PMox1	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
332	SRVV006	srvv-Proxy3x	TIC-Servidores-PMox1	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
333	SRVV007	srvv-SITIO	TIC-Servidores-Pmox1Servidor Web Sitio UTNLR; USR: Roberto CANIZA;	software	assigned	TIC	{"usr": "Roberto CANIZA"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
334	SRVV008	srvv-UNIFI	TIC-Servidores-PMox1	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
335	SRVV009	srvv-Sitio-0	TIC-Servidores-PMox2Servidor de Sitemas Webs Menores;	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
336	SRVV010	srvv-DTIC	TIC-Servidores-Pmox1	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
337	SRVV011	srv-FTPyIPCAMs	TIC-Servidores-Xen2X: EnDesuso, Ex servidor FTP e IPCams; HOST: NS04;	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
338	SRVV012	srvv-Sitio1	TIC-Servidores-Xen1	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
339	SRVV013	srvv-Sitio2	TIC-Servidores-Xen1	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
340	SRVV014	srvv-DHCPyDNS	TIC-Servidores-Xen1HOST: VNS5;	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
341	SRVV015	srvv-PROXY-PRIV	TIC-Servidores-Xen2HOST: NS03;	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
342	SRVV016	srvv-PROXY-PUB	TIC-Servidores-Xen2HOST: NS01;	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
343	SRVV017	srv-SiGesDOCs	TIC-Servidores-Xen1X: EnDesuso, Ex servidor de documentos UTNLR; HOST: NS10;	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
344	SRVV018	srv-SysACAD-WEB	TIC-Servidores-Xen2Servidor Web Microsoft (IIS) sistema SysACAD-Web; CRED: sysacadweb->$UTNlr...;	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
345	SRVV019	srvv-DockerTemp	TIC-Servidores-PMox1	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
346	SRVV020	srvv-TORRI	TIC-Servidores-PMox3Servidor Virtual de DNS [coreDNS];	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
347	SRVV021	srvv-TELEs	TIC-Servidores-DELL1	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
348	SRVV022	srvv-DATA	TIC-srvPMOX3	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
349	SRVV023	srvv-FENIX	TIC-Servidores-PMox3	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
350	SRVV024	srvv-DNS	TIC-Servidores-Pmox1Servidor Virtual de DNS [coreDNS];	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
351	SRVV025	srvv-SITIO2	TIC-Servidores-PMox3SITIO2 UTNLR; USR: Roberto CANIZA;	software	assigned	TIC	{"usr": "Roberto CANIZA"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
352	SRVV026	srvv-UPTIME	TIC-Servidores-PMox3Servidor de estados [UpTime Kuma];	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
353	SRVV027	srvv-N8N	TIC-Servidores-PMox3Servidor de Automatizaciones N8N;	software	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
354	SW001	sw-SW-01	GOB-Pasillo	network	available	GOB	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
355	SW002	sw-SW-02	ICI-Pasillo	network	available	ICI	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
356	SW003	sw-SW-03	ICI-Pasillo	network	available	ICI	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
357	SW004	sw-SW-04	IEM-Pasillo	network	available	IEM	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
358	SW005	sw-SW-05	TIC-Pasillo	network	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
359	SW006	sw-SW-06	IEL-Pasillo	network	available	IEL	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
360	SW007	sw-SW-07	TIC-Servidores	network	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
361	SW008	sw-TPLink	TIC-DTICMOD: SG2218;	network	available	TIC	{}	\N	SG2218	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
362	TBL001	tbl-TBL-01	OCT-BedelíaALUMNOS;	hardware	available	OCT	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
363	TEL001	tel-TELIP-01	DAS-DASUTeN	hardware	available	DAS	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
364	TEL002	tel-TELIP-02	OCT-PSICO	hardware	available	OCT	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
365	TEL003	tel-TELIP-03	TIC-DTICUSR: Ricardo MONLA; MARCA: YEALINK;	hardware	assigned	TIC	{"usr": "Ricardo MONLA"}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
366	TV001	tv-TV01		hardware	available	\N	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
367	TV002	tv-TV02		hardware	available	\N	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
368	TV003	tv-TV03		hardware	available	\N	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
369	TV004	tv-TV05	ICI-Auditorio	hardware	available	ICI	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
370	TV005	tv-TV06	TIC-DTICMARCA: Kanji;	hardware	available	TIC	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
371	TVBOX001	tvbox-TVBox01	OCT-Ingreso	hardware	available	OCT	{}	\N	\N	2025-11-14 20:59:07.550547+00	2025-11-14 20:59:07.550547+00
\.


--
-- Data for Name: tarea_recursos; Type: TABLE DATA; Schema: dtic; Owner: dtic_user
--

COPY dtic.tarea_recursos (id, tarea_id, recurso_id, assigned_by, assigned_at, unassigned_by, unassigned_at, activo, estimated_hours, actual_hours, notes) FROM stdin;
2	2	8	7	2025-11-04 21:48:08.869521+00	\N	\N	t	8.00	\N	Recurso asignado para reconfiguración del puerto KOHA
3	1	1	1	2025-11-07 20:09:00.553496+00	\N	\N	t	\N	\N	\N
\.


--
-- Data for Name: tareas; Type: TABLE DATA; Schema: dtic; Owner: dtic_user
--

COPY dtic.tareas (id, dtic_id, title, description, technician_id, status, priority, created_at, updated_at, due_date, completed_at) FROM stdin;
1	TAR-1249	Actualizar script nuevaBitacora.sh	Mejorar el script de generación de bitácoras para estandarizar registros automáticos	7	pending	medium	2025-11-03 19:57:37.00588+00	2025-11-03 19:57:37.00588+00	2025-11-10 23:59:59+00	\N
3	TAR-6204	Armado y testeo de UPS2	Armar UPS2 con baterías nuevas y realizar pruebas de carga y autonomía	1	pending	urgent	2025-11-03 19:58:14.057204+00	2025-11-04 19:16:33.376187+00	2025-11-05 23:59:59+00	\N
2	TAR-3273	Reconfigurar puerto KOHA 8080 → 80	Cambiar puerto de acceso de KOHA del 8080 al 80 y configurar DNS interno/externo	1	pending	high	2025-11-03 19:57:55.302421+00	2025-11-04 19:16:47.41898+00	2025-11-15 23:59:59+00	\N
4	TAR-3565	Actualización Servicios Docker srvv-DTIC	Actualizar servicios Docker y plataforma Unifi Network a versión 9.5.21	4	completed	medium	2025-11-03 19:58:21.741026+00	2025-11-04 19:36:21.599331+00	2025-11-08 23:59:59+00	2025-11-04 19:36:21.599331+00
\.


--
-- Data for Name: tecnicos; Type: TABLE DATA; Schema: dtic; Owner: dtic_user
--

COPY dtic.tecnicos (id, dtic_id, first_name, last_name, email, phone, department, role, password_hash, is_active, created_at, updated_at) FROM stdin;
4	TEC-0004	Ana	MARTÍNEZ	ana.martinez@dtic.gob.ar	\N	seguridad	technician	$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPjYQmHqU9yO	t	2025-11-01 21:09:56.299511+00	2025-11-01 21:09:56.299511+00
2	TEC-0002	Wilfredo	KRUPP	wkrupp@frlr.utn.edu.ar	\N	sistemas	technician	$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPjYQmHqU9yO	t	2025-11-01 21:09:56.299511+00	2025-11-03 21:04:54.277867+00
3	TEC-0003	Roberto	CANIZA	rcaniza@frlr.utn.edu.ar	\N	sistemas	technician	$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPjYQmHqU9yO	t	2025-11-01 21:09:56.299511+00	2025-11-03 21:06:04.697119+00
8	TEC-3543895	Juan Carlos	PEPE	pepe@pepe123.com	\N	dtic	admin	\N	t	2025-11-03 23:34:53.543556+00	2025-11-04 00:01:35.688127+00
7	TEC-0007	Ricardo	MONLA	rmonla@frlr.utn.edu.cl	\N	dtic	admin	$2a$12$T4OKj7qWBnjtYhXGmDibP.WszYyFIF5iKEZW3TDpVE2GI9Pfmu5zS	f	2025-11-01 21:09:56.299511+00	2025-11-04 00:52:10.12474+00
1	TEC-0001	Ricardo	MONLA	rmonla@frlr.utn.edu.ar	\N	dtic	admin	$2a$12$mvekc1y6v5DYadiSWcbtVu7coELOKQm5ZixXLYO6WU/O3UDGBYgC2	t	2025-11-01 21:09:56.299511+00	2025-11-14 21:50:17.13596+00
\.


--
-- Data for Name: usuarios_relacionados; Type: TABLE DATA; Schema: dtic; Owner: dtic_user
--

COPY dtic.usuarios_relacionados (id, dtic_id, first_name, last_name, email, phone, department, "position", created_at, updated_at) FROM stdin;
1	USR-0001	Juan	Pérez	juan.perez@empresa.com	+54 11 1234-5678	Administración	Gerente	2025-11-01 21:09:56.360668+00	2025-11-01 21:09:56.360668+00
2	USR-0002	María	González	maria.gonzalez@empresa.com	+54 11 2345-6789	Recursos Humanos	Coordinadora	2025-11-01 21:09:56.360668+00	2025-11-01 21:09:56.360668+00
3	USR-0003	Carlos	Rodríguez	carlos.rodriguez@empresa.com	+54 11 3456-7890	IT	Analista	2025-11-01 21:09:56.360668+00	2025-11-01 21:09:56.360668+00
4	USR-0004	Ana	Martínez	ana.martinez@empresa.com	+54 11 4567-8901	Contabilidad	Contadora	2025-11-01 21:09:56.360668+00	2025-11-01 21:09:56.360668+00
5	USR-0005	Luis	López	luis.lopez@empresa.com	+54 11 5678-9012	Ventas	Vendedor	2025-11-01 21:09:56.360668+00	2025-11-01 21:09:56.360668+00
6	USR-0006	Ricardo	MONLA	ricardo.monla@dtic.gob.ar	\N	dtic	Técnico Senior	2025-11-04 21:21:55.244194+00	2025-11-04 21:21:55.244194+00
\.


--
-- Name: audit_log_id_seq; Type: SEQUENCE SET; Schema: dtic; Owner: dtic_user
--

SELECT pg_catalog.setval('dtic.audit_log_id_seq', 1, false);


--
-- Name: recurso_asignaciones_id_seq; Type: SEQUENCE SET; Schema: dtic; Owner: dtic_user
--

SELECT pg_catalog.setval('dtic.recurso_asignaciones_id_seq', 3, true);


--
-- Name: recurso_historial_id_seq; Type: SEQUENCE SET; Schema: dtic; Owner: dtic_user
--

SELECT pg_catalog.setval('dtic.recurso_historial_id_seq', 1, false);


--
-- Name: recursos_id_seq; Type: SEQUENCE SET; Schema: dtic; Owner: dtic_user
--

SELECT pg_catalog.setval('dtic.recursos_id_seq', 371, true);


--
-- Name: tarea_recursos_id_seq; Type: SEQUENCE SET; Schema: dtic; Owner: dtic_user
--

SELECT pg_catalog.setval('dtic.tarea_recursos_id_seq', 3, true);


--
-- Name: tareas_id_seq; Type: SEQUENCE SET; Schema: dtic; Owner: dtic_user
--

SELECT pg_catalog.setval('dtic.tareas_id_seq', 4, true);


--
-- Name: tecnicos_id_seq; Type: SEQUENCE SET; Schema: dtic; Owner: dtic_user
--

SELECT pg_catalog.setval('dtic.tecnicos_id_seq', 8, true);


--
-- Name: usuarios_asignados_id_seq; Type: SEQUENCE SET; Schema: dtic; Owner: dtic_user
--

SELECT pg_catalog.setval('dtic.usuarios_asignados_id_seq', 6, true);


--
-- Name: audit_log audit_log_pkey; Type: CONSTRAINT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.audit_log
    ADD CONSTRAINT audit_log_pkey PRIMARY KEY (id);


--
-- Name: recurso_asignaciones recurso_asignaciones_pkey; Type: CONSTRAINT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.recurso_asignaciones
    ADD CONSTRAINT recurso_asignaciones_pkey PRIMARY KEY (id);


--
-- Name: recurso_asignaciones recurso_asignaciones_recurso_id_user_id_key; Type: CONSTRAINT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.recurso_asignaciones
    ADD CONSTRAINT recurso_asignaciones_recurso_id_user_id_key UNIQUE (recurso_id, user_id);


--
-- Name: recurso_historial recurso_historial_pkey; Type: CONSTRAINT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.recurso_historial
    ADD CONSTRAINT recurso_historial_pkey PRIMARY KEY (id);


--
-- Name: recursos recursos_dtic_id_key; Type: CONSTRAINT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.recursos
    ADD CONSTRAINT recursos_dtic_id_key UNIQUE (dtic_id);


--
-- Name: recursos recursos_pkey; Type: CONSTRAINT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.recursos
    ADD CONSTRAINT recursos_pkey PRIMARY KEY (id);


--
-- Name: tarea_recursos tarea_recursos_pkey; Type: CONSTRAINT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.tarea_recursos
    ADD CONSTRAINT tarea_recursos_pkey PRIMARY KEY (id);


--
-- Name: tarea_recursos tarea_recursos_tarea_id_recurso_id_activo_key; Type: CONSTRAINT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.tarea_recursos
    ADD CONSTRAINT tarea_recursos_tarea_id_recurso_id_activo_key UNIQUE (tarea_id, recurso_id, activo) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tareas tareas_dtic_id_key; Type: CONSTRAINT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.tareas
    ADD CONSTRAINT tareas_dtic_id_key UNIQUE (dtic_id);


--
-- Name: tareas tareas_pkey; Type: CONSTRAINT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.tareas
    ADD CONSTRAINT tareas_pkey PRIMARY KEY (id);


--
-- Name: tecnicos tecnicos_dtic_id_key; Type: CONSTRAINT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.tecnicos
    ADD CONSTRAINT tecnicos_dtic_id_key UNIQUE (dtic_id);


--
-- Name: tecnicos tecnicos_email_key; Type: CONSTRAINT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.tecnicos
    ADD CONSTRAINT tecnicos_email_key UNIQUE (email);


--
-- Name: tecnicos tecnicos_pkey; Type: CONSTRAINT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.tecnicos
    ADD CONSTRAINT tecnicos_pkey PRIMARY KEY (id);


--
-- Name: usuarios_relacionados usuarios_asignados_dtic_id_key; Type: CONSTRAINT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.usuarios_relacionados
    ADD CONSTRAINT usuarios_asignados_dtic_id_key UNIQUE (dtic_id);


--
-- Name: usuarios_relacionados usuarios_asignados_email_key; Type: CONSTRAINT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.usuarios_relacionados
    ADD CONSTRAINT usuarios_asignados_email_key UNIQUE (email);


--
-- Name: usuarios_relacionados usuarios_asignados_pkey; Type: CONSTRAINT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.usuarios_relacionados
    ADD CONSTRAINT usuarios_asignados_pkey PRIMARY KEY (id);


--
-- Name: idx_audit_created; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_audit_created ON dtic.audit_log USING btree (created_at);


--
-- Name: idx_audit_entity; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_audit_entity ON dtic.audit_log USING btree (entity_type, entity_id);


--
-- Name: idx_audit_user; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_audit_user ON dtic.audit_log USING btree (user_id);


--
-- Name: idx_recurso_asignaciones_activo; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_recurso_asignaciones_activo ON dtic.recurso_asignaciones USING btree (activo);


--
-- Name: idx_recurso_asignaciones_assigned_at; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_recurso_asignaciones_assigned_at ON dtic.recurso_asignaciones USING btree (assigned_at);


--
-- Name: idx_recurso_asignaciones_recurso; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_recurso_asignaciones_recurso ON dtic.recurso_asignaciones USING btree (recurso_id);


--
-- Name: idx_recurso_asignaciones_user; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_recurso_asignaciones_user ON dtic.recurso_asignaciones USING btree (user_id);


--
-- Name: idx_recurso_historial_action; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_recurso_historial_action ON dtic.recurso_historial USING btree (action);


--
-- Name: idx_recurso_historial_created; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_recurso_historial_created ON dtic.recurso_historial USING btree (created_at);


--
-- Name: idx_recurso_historial_recurso; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_recurso_historial_recurso ON dtic.recurso_historial USING btree (recurso_id);


--
-- Name: idx_recurso_historial_tecnico; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_recurso_historial_tecnico ON dtic.recurso_historial USING btree (tecnico_id);


--
-- Name: idx_recursos_category; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_recursos_category ON dtic.recursos USING btree (category);


--
-- Name: idx_recursos_dtic_id; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_recursos_dtic_id ON dtic.recursos USING btree (dtic_id);


--
-- Name: idx_recursos_location; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_recursos_location ON dtic.recursos USING btree (location);


--
-- Name: idx_recursos_name; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_recursos_name ON dtic.recursos USING gin (to_tsvector('spanish'::regconfig, (((((name)::text || ' '::text) || description) || ' '::text) || (dtic_id)::text)));


--
-- Name: idx_recursos_status; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_recursos_status ON dtic.recursos USING btree (status);


--
-- Name: idx_tarea_recursos_activo; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_tarea_recursos_activo ON dtic.tarea_recursos USING btree (activo);


--
-- Name: idx_tarea_recursos_recurso; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_tarea_recursos_recurso ON dtic.tarea_recursos USING btree (recurso_id);


--
-- Name: idx_tarea_recursos_tarea; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_tarea_recursos_tarea ON dtic.tarea_recursos USING btree (tarea_id);


--
-- Name: idx_tareas_due_date; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_tareas_due_date ON dtic.tareas USING btree (due_date);


--
-- Name: idx_tareas_priority; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_tareas_priority ON dtic.tareas USING btree (priority);


--
-- Name: idx_tareas_status; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_tareas_status ON dtic.tareas USING btree (status);


--
-- Name: idx_tareas_technician; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_tareas_technician ON dtic.tareas USING btree (technician_id);


--
-- Name: idx_tecnicos_active; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_tecnicos_active ON dtic.tecnicos USING btree (is_active);


--
-- Name: idx_tecnicos_department; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_tecnicos_department ON dtic.tecnicos USING btree (department);


--
-- Name: idx_tecnicos_dtic_id; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_tecnicos_dtic_id ON dtic.tecnicos USING btree (dtic_id);


--
-- Name: idx_tecnicos_email; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_tecnicos_email ON dtic.tecnicos USING btree (email);


--
-- Name: idx_tecnicos_full_name; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_tecnicos_full_name ON dtic.tecnicos USING gin (to_tsvector('spanish'::regconfig, (((first_name)::text || ' '::text) || (last_name)::text)));


--
-- Name: idx_tecnicos_role; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_tecnicos_role ON dtic.tecnicos USING btree (role);


--
-- Name: idx_tecnicos_search; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_tecnicos_search ON dtic.tecnicos USING gin (to_tsvector('spanish'::regconfig, (((((((first_name)::text || ' '::text) || (last_name)::text) || ' '::text) || (email)::text) || ' '::text) || (dtic_id)::text)));


--
-- Name: idx_usuarios_asignados_department; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_usuarios_asignados_department ON dtic.usuarios_relacionados USING btree (department);


--
-- Name: idx_usuarios_asignados_dtic_id; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_usuarios_asignados_dtic_id ON dtic.usuarios_relacionados USING btree (dtic_id);


--
-- Name: idx_usuarios_asignados_email; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_usuarios_asignados_email ON dtic.usuarios_relacionados USING btree (email);


--
-- Name: idx_usuarios_asignados_name; Type: INDEX; Schema: dtic; Owner: dtic_user
--

CREATE INDEX idx_usuarios_asignados_name ON dtic.usuarios_relacionados USING gin (to_tsvector('spanish'::regconfig, (((((((first_name)::text || ' '::text) || (last_name)::text) || ' '::text) || (email)::text) || ' '::text) || (dtic_id)::text)));


--
-- Name: recursos update_recursos_updated_at; Type: TRIGGER; Schema: dtic; Owner: dtic_user
--

CREATE TRIGGER update_recursos_updated_at BEFORE UPDATE ON dtic.recursos FOR EACH ROW EXECUTE FUNCTION dtic.update_updated_at_column();


--
-- Name: tareas update_tareas_updated_at; Type: TRIGGER; Schema: dtic; Owner: dtic_user
--

CREATE TRIGGER update_tareas_updated_at BEFORE UPDATE ON dtic.tareas FOR EACH ROW EXECUTE FUNCTION dtic.update_updated_at_column();


--
-- Name: tecnicos update_tecnicos_updated_at; Type: TRIGGER; Schema: dtic; Owner: dtic_user
--

CREATE TRIGGER update_tecnicos_updated_at BEFORE UPDATE ON dtic.tecnicos FOR EACH ROW EXECUTE FUNCTION dtic.update_updated_at_column();


--
-- Name: usuarios_relacionados update_usuarios_asignados_updated_at; Type: TRIGGER; Schema: dtic; Owner: dtic_user
--

CREATE TRIGGER update_usuarios_asignados_updated_at BEFORE UPDATE ON dtic.usuarios_relacionados FOR EACH ROW EXECUTE FUNCTION dtic.update_updated_at_column();


--
-- Name: audit_log audit_log_user_id_fkey; Type: FK CONSTRAINT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.audit_log
    ADD CONSTRAINT audit_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES dtic.tecnicos(id) ON DELETE SET NULL;


--
-- Name: recurso_asignaciones recurso_asignaciones_assigned_by_fkey; Type: FK CONSTRAINT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.recurso_asignaciones
    ADD CONSTRAINT recurso_asignaciones_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES dtic.tecnicos(id);


--
-- Name: recurso_asignaciones recurso_asignaciones_recurso_id_fkey; Type: FK CONSTRAINT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.recurso_asignaciones
    ADD CONSTRAINT recurso_asignaciones_recurso_id_fkey FOREIGN KEY (recurso_id) REFERENCES dtic.recursos(id) ON DELETE CASCADE;


--
-- Name: recurso_asignaciones recurso_asignaciones_unassigned_by_fkey; Type: FK CONSTRAINT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.recurso_asignaciones
    ADD CONSTRAINT recurso_asignaciones_unassigned_by_fkey FOREIGN KEY (unassigned_by) REFERENCES dtic.tecnicos(id);


--
-- Name: recurso_asignaciones recurso_asignaciones_user_id_fkey; Type: FK CONSTRAINT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.recurso_asignaciones
    ADD CONSTRAINT recurso_asignaciones_user_id_fkey FOREIGN KEY (user_id) REFERENCES dtic.usuarios_relacionados(id) ON DELETE CASCADE;


--
-- Name: recurso_historial recurso_historial_recurso_id_fkey; Type: FK CONSTRAINT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.recurso_historial
    ADD CONSTRAINT recurso_historial_recurso_id_fkey FOREIGN KEY (recurso_id) REFERENCES dtic.recursos(id) ON DELETE CASCADE;


--
-- Name: recurso_historial recurso_historial_tecnico_id_fkey; Type: FK CONSTRAINT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.recurso_historial
    ADD CONSTRAINT recurso_historial_tecnico_id_fkey FOREIGN KEY (tecnico_id) REFERENCES dtic.tecnicos(id);


--
-- Name: recurso_historial recurso_historial_usuario_id_fkey; Type: FK CONSTRAINT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.recurso_historial
    ADD CONSTRAINT recurso_historial_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES dtic.usuarios_relacionados(id);


--
-- Name: tarea_recursos tarea_recursos_assigned_by_fkey; Type: FK CONSTRAINT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.tarea_recursos
    ADD CONSTRAINT tarea_recursos_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES dtic.tecnicos(id);


--
-- Name: tarea_recursos tarea_recursos_recurso_id_fkey; Type: FK CONSTRAINT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.tarea_recursos
    ADD CONSTRAINT tarea_recursos_recurso_id_fkey FOREIGN KEY (recurso_id) REFERENCES dtic.recursos(id) ON DELETE CASCADE;


--
-- Name: tarea_recursos tarea_recursos_tarea_id_fkey; Type: FK CONSTRAINT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.tarea_recursos
    ADD CONSTRAINT tarea_recursos_tarea_id_fkey FOREIGN KEY (tarea_id) REFERENCES dtic.tareas(id) ON DELETE CASCADE;


--
-- Name: tarea_recursos tarea_recursos_unassigned_by_fkey; Type: FK CONSTRAINT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.tarea_recursos
    ADD CONSTRAINT tarea_recursos_unassigned_by_fkey FOREIGN KEY (unassigned_by) REFERENCES dtic.tecnicos(id);


--
-- Name: tareas tareas_technician_id_fkey; Type: FK CONSTRAINT; Schema: dtic; Owner: dtic_user
--

ALTER TABLE ONLY dtic.tareas
    ADD CONSTRAINT tareas_technician_id_fkey FOREIGN KEY (technician_id) REFERENCES dtic.tecnicos(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict cFYgHqr7l0QRJhLjpOKKHk9S4KslS85HUu2KD0bA2qOH0RiLRMLUafVJ0QoaueS

