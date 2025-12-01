--
-- PostgreSQL database dump
--

\restrict K4hWu6dLGDNzRDCx02tVlbJe73glE0EYbLMyKNmWtoqGgdDQL71SeS3t1J15PBM

-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.0

-- Started on 2025-11-30 23:11:57

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 230 (class 1259 OID 57345)
-- Name: caf; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.caf (
    id integer NOT NULL,
    emitter_id integer NOT NULL,
    tipo_dte integer NOT NULL,
    folio_inicial integer NOT NULL,
    folio_final integer NOT NULL,
    folio_actual integer NOT NULL,
    fecha_autorizacion date NOT NULL,
    fecha_vencimiento date,
    caf_xml text NOT NULL,
    is_active boolean NOT NULL
);


ALTER TABLE public.caf OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 57344)
-- Name: caf_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.caf_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.caf_id_seq OWNER TO postgres;

--
-- TOC entry 5009 (class 0 OID 0)
-- Dependencies: 229
-- Name: caf_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.caf_id_seq OWNED BY public.caf.id;


--
-- TOC entry 220 (class 1259 OID 49155)
-- Name: clients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clients (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    contact_email character varying(200) NOT NULL,
    api_key character varying(255) NOT NULL,
    is_active boolean
);


ALTER TABLE public.clients OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 49154)
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clients_id_seq OWNER TO postgres;

--
-- TOC entry 5010 (class 0 OID 0)
-- Dependencies: 219
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clients_id_seq OWNED BY public.clients.id;


--
-- TOC entry 226 (class 1259 OID 49220)
-- Name: document_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.document_items (
    id integer NOT NULL,
    document_id integer NOT NULL,
    descripcion character varying(255) NOT NULL,
    cantidad numeric(15,2) NOT NULL,
    precio_unitario numeric(15,2) NOT NULL,
    descuento numeric(15,2),
    total_linea numeric(15,2) NOT NULL
);


ALTER TABLE public.document_items OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 49219)
-- Name: document_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.document_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.document_items_id_seq OWNER TO postgres;

--
-- TOC entry 5011 (class 0 OID 0)
-- Dependencies: 225
-- Name: document_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.document_items_id_seq OWNED BY public.document_items.id;


--
-- TOC entry 224 (class 1259 OID 49190)
-- Name: documents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.documents (
    id integer NOT NULL,
    client_id integer NOT NULL,
    emitter_id integer NOT NULL,
    tipo_dte integer NOT NULL,
    folio integer,
    receptor_rut character varying(20) NOT NULL,
    receptor_razon_social character varying(255) NOT NULL,
    receptor_direccion character varying(255),
    receptor_comuna character varying(100),
    monto_neto numeric(15,2) NOT NULL,
    monto_iva numeric(15,2) NOT NULL,
    monto_total numeric(15,2) NOT NULL,
    sii_track_id character varying(50),
    sii_state character varying(50),
    error_last_message text,
    raw_xml text,
    pdf_path character varying(255),
    envio_xml text
);


ALTER TABLE public.documents OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 49189)
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.documents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.documents_id_seq OWNER TO postgres;

--
-- TOC entry 5012 (class 0 OID 0)
-- Dependencies: 223
-- Name: documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.documents_id_seq OWNED BY public.documents.id;


--
-- TOC entry 222 (class 1259 OID 49170)
-- Name: emitters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.emitters (
    id integer NOT NULL,
    client_id integer NOT NULL,
    rut_emisor character varying(20) NOT NULL,
    razon_social character varying(255) NOT NULL,
    direccion character varying(255),
    comuna character varying(100),
    giro character varying(255),
    cert_alias character varying(100),
    sii_environment character varying(10),
    sii_status character varying(50)
);


ALTER TABLE public.emitters OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 49169)
-- Name: emitters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.emitters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.emitters_id_seq OWNER TO postgres;

--
-- TOC entry 5013 (class 0 OID 0)
-- Dependencies: 221
-- Name: emitters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.emitters_id_seq OWNED BY public.emitters.id;


--
-- TOC entry 228 (class 1259 OID 49239)
-- Name: log_events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.log_events (
    id integer NOT NULL,
    document_id integer,
    client_id integer,
    level character varying(20),
    origin character varying(50),
    message character varying(255) NOT NULL,
    payload text
);


ALTER TABLE public.log_events OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 49238)
-- Name: log_events_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.log_events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.log_events_id_seq OWNER TO postgres;

--
-- TOC entry 5014 (class 0 OID 0)
-- Dependencies: 227
-- Name: log_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.log_events_id_seq OWNED BY public.log_events.id;


--
-- TOC entry 234 (class 1259 OID 81944)
-- Name: user_activity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_activity (
    id integer NOT NULL,
    user_id integer,
    client_id integer,
    action character varying(100) NOT NULL,
    method character varying(10) NOT NULL,
    path character varying(255) NOT NULL,
    status_code integer NOT NULL,
    success boolean NOT NULL,
    error_message text,
    ip_address character varying(50),
    user_agent character varying(255),
    extra jsonb,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_activity OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 81943)
-- Name: user_activity_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_activity_id_seq OWNER TO postgres;

--
-- TOC entry 5015 (class 0 OID 0)
-- Dependencies: 233
-- Name: user_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_activity_id_seq OWNED BY public.user_activity.id;


--
-- TOC entry 232 (class 1259 OID 81927)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    username character varying(255) NOT NULL,
    hashed_password character varying(255) NOT NULL,
    is_active boolean,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 81926)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 5016 (class 0 OID 0)
-- Dependencies: 231
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 4795 (class 2604 OID 57348)
-- Name: caf id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caf ALTER COLUMN id SET DEFAULT nextval('public.caf_id_seq'::regclass);


--
-- TOC entry 4790 (class 2604 OID 49158)
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);


--
-- TOC entry 4793 (class 2604 OID 49223)
-- Name: document_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.document_items ALTER COLUMN id SET DEFAULT nextval('public.document_items_id_seq'::regclass);


--
-- TOC entry 4792 (class 2604 OID 49193)
-- Name: documents id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documents ALTER COLUMN id SET DEFAULT nextval('public.documents_id_seq'::regclass);


--
-- TOC entry 4791 (class 2604 OID 49173)
-- Name: emitters id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emitters ALTER COLUMN id SET DEFAULT nextval('public.emitters_id_seq'::regclass);


--
-- TOC entry 4794 (class 2604 OID 49242)
-- Name: log_events id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_events ALTER COLUMN id SET DEFAULT nextval('public.log_events_id_seq'::regclass);


--
-- TOC entry 4798 (class 2604 OID 81947)
-- Name: user_activity id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_activity ALTER COLUMN id SET DEFAULT nextval('public.user_activity_id_seq'::regclass);


--
-- TOC entry 4796 (class 2604 OID 81930)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 4999 (class 0 OID 57345)
-- Dependencies: 230
-- Data for Name: caf; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.caf (id, emitter_id, tipo_dte, folio_inicial, folio_final, folio_actual, fecha_autorizacion, fecha_vencimiento, caf_xml, is_active) FROM stdin;
1	1	33	100	200	131	2025-11-20	\N	<AUTORIZACION>XML DEL CAF AQUÍ...</AUTORIZACION>	t
\.


--
-- TOC entry 4989 (class 0 OID 49155)
-- Dependencies: 220
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clients (id, name, contact_email, api_key, is_active) FROM stdin;
1	prueba	alvarovillaloboshuerta1997@gmail.com	YVeDzc-FbDokpVfsNRbUeFUhrPGjPN-VKR3o8G4XNjs	t
\.


--
-- TOC entry 4995 (class 0 OID 49220)
-- Dependencies: 226
-- Data for Name: document_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.document_items (id, document_id, descripcion, cantidad, precio_unitario, descuento, total_linea) FROM stdin;
1	1	Servicio de Desarrollo	1.00	200000.00	\N	200000.00
2	1	Hosting mensual	1.00	15000.00	\N	15000.00
3	2	Servicio de Desarrollo	1.00	200000.00	\N	200000.00
4	2	Hosting mensual	1.00	15000.00	\N	15000.00
5	3	Servicio de Desarrollo	1.00	200000.00	\N	200000.00
6	3	Hosting Mensual	1.00	15000.00	\N	15000.00
7	4	Servicio de Desarrollo	1.00	200000.00	\N	200000.00
8	4	Hosting Mensual	1.00	15000.00	\N	15000.00
9	5	Servicio de Desarrollo	1.00	200000.00	\N	200000.00
10	5	Hosting Mensual	1.00	15000.00	\N	15000.00
11	6	Servicio de Desarrollo	1.00	200000.00	\N	200000.00
12	6	Hosting Mensual	1.00	15000.00	\N	15000.00
13	7	Servicio de Desarrollo	1.00	200000.00	\N	200000.00
14	7	Hosting Mensual	1.00	15000.00	\N	15000.00
15	8	Servicio de Desarrollo	1.00	200000.00	\N	200000.00
16	8	Hosting Mensual	1.00	15000.00	\N	15000.00
17	9	Servicio de Desarrollo	1.00	200000.00	\N	200000.00
18	9	Hosting Mensual	1.00	15000.00	\N	15000.00
19	10	Servicio de Desarrollo	1.00	200000.00	\N	200000.00
20	10	Hosting Mensual	1.00	15000.00	\N	15000.00
21	11	Servicio de Desarrollo	1.00	200000.00	\N	200000.00
22	11	Hosting Mensual	1.00	15000.00	\N	15000.00
23	12	Servicio de Desarrollo	1.00	200000.00	\N	200000.00
24	12	Hosting Mensual	1.00	15000.00	\N	15000.00
25	13	Servicio de Desarrollo	1.00	200000.00	\N	200000.00
26	13	Hosting Mensual	1.00	15000.00	\N	15000.00
27	14	Servicio de Desarrollo	1.00	200000.00	\N	200000.00
28	14	Hosting Mensual	1.00	15000.00	\N	15000.00
29	15	Servicio de Desarrollo	1.00	200000.00	\N	200000.00
30	15	Hosting Mensual	1.00	15000.00	\N	15000.00
31	16	Servicio de Desarrollo	1.00	200000.00	\N	200000.00
32	16	Hosting Mensual	1.00	15000.00	\N	15000.00
33	17	Servicio de Desarrollo	1.00	200000.00	\N	200000.00
34	17	Hosting Mensual	1.00	15000.00	\N	15000.00
35	18	Servicio de Desarrollo	1.00	200000.00	\N	200000.00
36	18	Hosting Mensual	1.00	15000.00	\N	15000.00
37	19	Servicio de Desarrollo	1.00	200000.00	\N	200000.00
38	19	Hosting Mensual	1.00	15000.00	\N	15000.00
39	20	Servicio de Desarrollo	1.00	200000.00	\N	200000.00
40	20	Hosting Mensual	1.00	15000.00	\N	15000.00
41	21	Servicio de Desarrollo	1.00	200000.00	\N	200000.00
42	21	Hosting Mensual	1.00	15000.00	\N	15000.00
43	22	Servicio de Desarrollo	1.00	200000.00	\N	200000.00
44	22	Hosting Mensual	1.00	15000.00	\N	15000.00
45	23	Servicio de Desarrollo	1.00	200000.00	0.00	200000.00
46	23	Hosting Mensual	1.00	15000.00	0.00	15000.00
47	24	Servicio X	1.00	1000.00	\N	1000.00
48	25	Servicio X	1.00	1000.00	\N	1000.00
49	26	Servicio X	1.00	1000.00	\N	1000.00
50	27	Servicio X	1.00	1000.00	\N	1000.00
51	28	Servicio X	1.00	1000.00	\N	1000.00
52	29	Servicio X	1.00	1000.00	\N	1000.00
53	30	Servicio X	1.00	1000.00	\N	1000.00
54	31	Servicio X	1.00	1000.00	\N	1000.00
55	32	Servicio X	1.00	1000.00	\N	1000.00
56	33	Servicio X	1.00	1000.00	\N	1000.00
57	34	Servicio X	1.00	1000.00	\N	1000.00
58	35	Servicio X	1.00	1000.00	\N	1000.00
\.


--
-- TOC entry 4993 (class 0 OID 49190)
-- Dependencies: 224
-- Data for Name: documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.documents (id, client_id, emitter_id, tipo_dte, folio, receptor_rut, receptor_razon_social, receptor_direccion, receptor_comuna, monto_neto, monto_iva, monto_total, sii_track_id, sii_state, error_last_message, raw_xml, pdf_path, envio_xml) FROM stdin;
1	1	1	33	\N	22222222-2	Cliente Prueba Ltda	Calle Falsa 456	Providencia	215000.00	40850.00	255850.00	\N	CREADO	\N	\N	\N	\N
2	1	1	33	\N	22222222-2	Cliente Prueba Ltda	Calle Falsa 456	Providencia	215000.00	40850.00	255850.00	1BFFADEE7AA7	ENVIADO	\N	<?xml version="1.0" encoding="ISO-8859-1"?>\n<DTE>\n    <Encabezado>\n        <IdDoc>\n            <TipoDTE>33</TipoDTE>\n            <Folio></Folio>\n            <FchEmis>2025-11-16</FchEmis>\n        </IdDoc>\n        <Emisor>\n            <RUTEmisor>11111111-1</RUTEmisor>\n            <RznSoc>Mi Pyme SpA</RznSoc>\n        </Emisor>\n        <Receptor>\n            <RUTRecep>22222222-2</RUTRecep>\n            <RznSocRecep>Cliente Prueba Ltda</RznSocRecep>\n        </Receptor>\n        <Totales>\n            <MntNeto>215000</MntNeto>\n            <IVA>40850</IVA>\n            <MntTotal>255850</MntTotal>\n        </Totales>\n    </Encabezado>\n    <DetalleItems>\n        \n            <Detalle>\n                <Descripcion>Servicio de Desarrollo</Descripcion>\n                <Cantidad>1.00</Cantidad>\n                <PrecioUnitario>200000.00</PrecioUnitario>\n                <TotalLinea>200000.00</TotalLinea>\n            </Detalle>\n            \n\n            <Detalle>\n                <Descripcion>Hosting mensual</Descripcion>\n                <Cantidad>1.00</Cantidad>\n                <PrecioUnitario>15000.00</PrecioUnitario>\n                <TotalLinea>15000.00</TotalLinea>\n            </Detalle>\n            \n    </DetalleItems>\n</DTE>\n	\N	\N
3	1	1	33	\N	22222222-2	Cliente Prueba Ltda	Av. Central 123	Santiago	215000.00	40850.00	255850.00	74966B9F8100	ENVIADO	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<DTE version="1.0"><Documento ID="F33T3"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><FchEmis>2025-11-18</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>22222222-2</RUTRecep><RznSocRecep>Cliente Prueba Ltda</RznSocRecep><DirRecep>Av. Central 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>215000</MntNeto><IVA>40850</IVA><MntTotal>255850</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio de Desarrollo</NmbItem><QtyItem>1.00</QtyItem><PrcItem>200000.00</PrcItem><MontoItem>200000</MontoItem></Detalle><Detalle><NroLinDet>2</NroLinDet><NmbItem>Hosting Mensual</NmbItem><QtyItem>1.00</QtyItem><PrcItem>15000.00</PrcItem><MontoItem>15000</MontoItem></Detalle></Documento></DTE>	\N	\N
4	1	1	33	\N	22222222-2	Cliente Prueba Ltda	Av. Central 123	Santiago	215000.00	40850.00	255850.00	D7CAE7DDD35D	ENVIADO	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<DTE version="1.0"><Documento ID="F33T4"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><FchEmis>2025-11-18</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>22222222-2</RUTRecep><RznSocRecep>Cliente Prueba Ltda</RznSocRecep><DirRecep>Av. Central 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>215000</MntNeto><IVA>40850</IVA><MntTotal>255850</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio de Desarrollo</NmbItem><QtyItem>1.00</QtyItem><PrcItem>200000.00</PrcItem><MontoItem>200000</MontoItem></Detalle><Detalle><NroLinDet>2</NroLinDet><NmbItem>Hosting Mensual</NmbItem><QtyItem>1.00</QtyItem><PrcItem>15000.00</PrcItem><MontoItem>15000</MontoItem></Detalle><TED version="1.0"><DD><TD>33</TD><F>4</F><RE>11111111-1</RE><RR>22222222-2</RR><MNT>255850</MNT></DD><FRMA algoritmo="SHA1withRSA">PLACEHOLDER</FRMA></TED><TmstFirma>2025-11-18T02:19:51</TmstFirma></Documento></DTE>	\N	\N
5	1	1	33	100	22222222-2	Cliente Prueba Ltda	Av. Central 123	Santiago	215000.00	40850.00	255850.00	CA2702AF622A	ENVIADO	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<DTE version="1.0"><Documento ID="F33T5"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><FchEmis>2025-11-20</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>22222222-2</RUTRecep><RznSocRecep>Cliente Prueba Ltda</RznSocRecep><DirRecep>Av. Central 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>215000</MntNeto><IVA>40850</IVA><MntTotal>255850</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio de Desarrollo</NmbItem><QtyItem>1.00</QtyItem><PrcItem>200000.00</PrcItem><MontoItem>200000</MontoItem></Detalle><Detalle><NroLinDet>2</NroLinDet><NmbItem>Hosting Mensual</NmbItem><QtyItem>1.00</QtyItem><PrcItem>15000.00</PrcItem><MontoItem>15000</MontoItem></Detalle><TED version="1.0"><DD><TD>33</TD><F>5</F><RE>11111111-1</RE><RR>22222222-2</RR><MNT>255850</MNT></DD><FRMA algoritmo="SHA1withRSA">PLACEHOLDER</FRMA></TED><TmstFirma>2025-11-20T01:21:52</TmstFirma></Documento></DTE>	\N	\N
6	1	1	33	101	22222222-2	Cliente Prueba Ltda	Av. Central 123	Santiago	215000.00	40850.00	255850.00	E65A99902BF5	ENVIADO	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<DTE version="1.0"><Documento ID="F33T6"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><FchEmis>2025-11-20</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>22222222-2</RUTRecep><RznSocRecep>Cliente Prueba Ltda</RznSocRecep><DirRecep>Av. Central 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>215000</MntNeto><IVA>40850</IVA><MntTotal>255850</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio de Desarrollo</NmbItem><QtyItem>1.00</QtyItem><PrcItem>200000.00</PrcItem><MontoItem>200000</MontoItem></Detalle><Detalle><NroLinDet>2</NroLinDet><NmbItem>Hosting Mensual</NmbItem><QtyItem>1.00</QtyItem><PrcItem>15000.00</PrcItem><MontoItem>15000</MontoItem></Detalle><TED version="1.0"><DD><TD>33</TD><F>6</F><RE>11111111-1</RE><RR>22222222-2</RR><MNT>255850</MNT></DD><FRMA algoritmo="SHA1withRSA">PLACEHOLDER</FRMA></TED><TmstFirma>2025-11-20T01:41:12</TmstFirma></Documento></DTE>	\N	\N
7	1	1	33	102	22222222-2	Cliente Prueba Ltda	Av. Central 123	Santiago	215000.00	40850.00	255850.00	817C8F6498EA	ENVIADO	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<DTE version="1.0"><Documento ID="F33T7"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>102</Folio><FchEmis>2025-11-20</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>22222222-2</RUTRecep><RznSocRecep>Cliente Prueba Ltda</RznSocRecep><DirRecep>Av. Central 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>215000</MntNeto><IVA>40850</IVA><MntTotal>255850</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio de Desarrollo</NmbItem><QtyItem>1.00</QtyItem><PrcItem>200000.00</PrcItem><MontoItem>200000</MontoItem></Detalle><Detalle><NroLinDet>2</NroLinDet><NmbItem>Hosting Mensual</NmbItem><QtyItem>1.00</QtyItem><PrcItem>15000.00</PrcItem><MontoItem>15000</MontoItem></Detalle><TED version="1.0"><DD><TD>33</TD><F>102</F><RE>11111111-1</RE><RR>22222222-2</RR><MNT>255850</MNT></DD><FRMA algoritmo="SHA1withRSA">PLACEHOLDER</FRMA></TED><TmstFirma>2025-11-20T02:12:00</TmstFirma></Documento></DTE>	\N	\N
8	1	1	33	103	22222222-2	Cliente Prueba Ltda	Av. Central 123	Santiago	215000.00	40850.00	255850.00	E831CD4E0FD3	ENVIADO	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<DTE version="1.0"><Documento ID="F33T8"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>103</Folio><FchEmis>2025-11-20</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>22222222-2</RUTRecep><RznSocRecep>Cliente Prueba Ltda</RznSocRecep><DirRecep>Av. Central 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>215000</MntNeto><IVA>40850</IVA><MntTotal>255850</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio de Desarrollo</NmbItem><QtyItem>1.00</QtyItem><PrcItem>200000.00</PrcItem><MontoItem>200000</MontoItem></Detalle><Detalle><NroLinDet>2</NroLinDet><NmbItem>Hosting Mensual</NmbItem><QtyItem>1.00</QtyItem><PrcItem>15000.00</PrcItem><MontoItem>15000</MontoItem></Detalle><TED version="1.0"><DD><TD>33</TD><F>103</F><RE>11111111-1</RE><RR>22222222-2</RR><MNT>255850</MNT></DD><FRMA algoritmo="SHA1withRSA">PLACEHOLDER</FRMA></TED><TmstFirma>2025-11-20T22:42:04</TmstFirma></Documento></DTE>	\N	\N
9	1	1	33	104	22222222-2	Cliente Prueba Ltda	Av. Central 123	Santiago	215000.00	40850.00	255850.00	499C623F97AB	ENVIADO	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<DTE version="1.0"><Documento ID="F33T9"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>104</Folio><FchEmis>2025-11-20</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>22222222-2</RUTRecep><RznSocRecep>Cliente Prueba Ltda</RznSocRecep><DirRecep>Av. Central 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>215000</MntNeto><IVA>40850</IVA><MntTotal>255850</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio de Desarrollo</NmbItem><QtyItem>1.00</QtyItem><PrcItem>200000.00</PrcItem><MontoItem>200000</MontoItem></Detalle><Detalle><NroLinDet>2</NroLinDet><NmbItem>Hosting Mensual</NmbItem><QtyItem>1.00</QtyItem><PrcItem>15000.00</PrcItem><MontoItem>15000</MontoItem></Detalle><TED version="1.0"><DD><TD>33</TD><F>104</F><RE>11111111-1</RE><RR>22222222-2</RR><MNT>255850</MNT></DD><FRMA algoritmo="SHA1withRSA">PLACEHOLDER</FRMA></TED><TmstFirma>2025-11-20T22:44:11</TmstFirma></Documento></DTE>	\N	\N
10	1	1	33	105	22222222-2	Cliente Prueba Ltda	Av. Central 123	Santiago	215000.00	40850.00	255850.00	\N	CREADO	\N	\N	\N	\N
11	1	1	33	106	22222222-2	Cliente Prueba Ltda	Av. Central 123	Santiago	215000.00	40850.00	255850.00	\N	CREADO	\N	\N	\N	\N
12	1	1	33	107	22222222-2	Cliente Prueba Ltda	Av. Central 123	Santiago	215000.00	40850.00	255850.00	\N	CREADO	\N	\N	\N	\N
13	1	1	33	108	22222222-2	Cliente Prueba Ltda	Av. Central 123	Santiago	215000.00	40850.00	255850.00	\N	CREADO	\N	\N	\N	\N
14	1	1	33	109	22222222-2	Cliente Prueba Ltda	Av. Central 123	Santiago	215000.00	40850.00	255850.00	\N	CREADO	\N	\N	\N	\N
15	1	1	33	110	22222222-2	Cliente Prueba Ltda	Av. Central 123	Santiago	215000.00	40850.00	255850.00	\N	CREADO	\N	\N	\N	\N
16	1	1	33	111	22222222-2	Cliente Prueba Ltda	Av. Central 123	Santiago	215000.00	40850.00	255850.00	B6DAF8EB3B71	ENVIADO	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<DTE version="1.0"><Documento ID="F33T16"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>111</Folio><FchEmis>2025-11-21</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>22222222-2</RUTRecep><RznSocRecep>Cliente Prueba Ltda</RznSocRecep><DirRecep>Av. Central 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>215000</MntNeto><IVA>40850</IVA><MntTotal>255850</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio de Desarrollo</NmbItem><QtyItem>1.00</QtyItem><PrcItem>200000.00</PrcItem><MontoItem>200000</MontoItem></Detalle><Detalle><NroLinDet>2</NroLinDet><NmbItem>Hosting Mensual</NmbItem><QtyItem>1.00</QtyItem><PrcItem>15000.00</PrcItem><MontoItem>15000</MontoItem></Detalle><TED version="1.0"><DD><RE>11111111-1</RE><TD>33</TD><F>111</F><FE>20251121</FE><RR>22222222-2</RR><RSR>CLIENTE PRUEBA LTDA</RSR><MNT>255850</MNT><IT1>Servicio de Desarrollo</IT1><TSTED>2025-11-21T00:42:24</TSTED></DD><FRMA algoritmo="SHA1withRSA">PLACEHOLDER</FRMA></TED><TmstFirma>2025-11-21T00:42:24</TmstFirma></Documento></DTE>	\N	\N
17	1	1	33	112	22222222-2	Cliente Prueba Ltda	Av. Central 123	Santiago	215000.00	40850.00	255850.00	13AD436770E1	ENVIADO	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<DTE version="1.0"><Documento ID="F33T17"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>112</Folio><FchEmis>2025-11-21</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>22222222-2</RUTRecep><RznSocRecep>Cliente Prueba Ltda</RznSocRecep><DirRecep>Av. Central 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>215000</MntNeto><IVA>40850</IVA><MntTotal>255850</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio de Desarrollo</NmbItem><QtyItem>1.00</QtyItem><PrcItem>200000.00</PrcItem><MontoItem>200000</MontoItem></Detalle><Detalle><NroLinDet>2</NroLinDet><NmbItem>Hosting Mensual</NmbItem><QtyItem>1.00</QtyItem><PrcItem>15000.00</PrcItem><MontoItem>15000</MontoItem></Detalle><TED version="1.0"><DD><RE>11111111-1</RE><TD>33</TD><F>112</F><FE>20251121</FE><RR>22222222-2</RR><RSR>CLIENTE PRUEBA LTDA</RSR><MNT>255850</MNT><IT1>Servicio de Desarrollo</IT1><TSTED>2025-11-21T00:45:54</TSTED></DD><FRMA algoritmo="SHA1withRSA">PLACEHOLDER</FRMA></TED><TmstFirma>2025-11-21T00:45:54</TmstFirma></Documento></DTE>	\N	\N
18	1	1	33	113	22222222-2	Cliente Prueba Ltda	Av. Central 123	Santiago	215000.00	40850.00	255850.00	82222C18F859	ENVIADO	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<DTE version="1.0"><Documento ID="F33T18"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>113</Folio><FchEmis>2025-11-21</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>22222222-2</RUTRecep><RznSocRecep>Cliente Prueba Ltda</RznSocRecep><DirRecep>Av. Central 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>215000</MntNeto><IVA>40850</IVA><MntTotal>255850</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio de Desarrollo</NmbItem><QtyItem>1.00</QtyItem><PrcItem>200000.00</PrcItem><MontoItem>200000</MontoItem></Detalle><Detalle><NroLinDet>2</NroLinDet><NmbItem>Hosting Mensual</NmbItem><QtyItem>1.00</QtyItem><PrcItem>15000.00</PrcItem><MontoItem>15000</MontoItem></Detalle><TED version="1.0"><DD><RE>11111111-1</RE><TD>33</TD><F>113</F><FE>20251121</FE><RR>22222222-2</RR><RSR>CLIENTE PRUEBA LTDA</RSR><MNT>255850</MNT><IT1>Servicio de Desarrollo</IT1><TSTED>2025-11-21T00:55:35</TSTED></DD><FRMA algoritmo="SHA1withRSA">PLACEHOLDER</FRMA></TED><TmstFirma>2025-11-21T00:55:35</TmstFirma></Documento></DTE>	\N	\N
19	1	1	33	114	22222222-2	Cliente Prueba Ltda	Av. Central 123	Santiago	215000.00	40850.00	255850.00	\N	ERROR	unknown method 'c14n'	\N	\N	\N
20	1	1	33	115	22222222-2	Cliente Prueba Ltda	Av. Central 123	Santiago	215000.00	40850.00	255850.00	\N	ERROR	unknown method 'c14n'	\N	\N	\N
21	1	1	33	116	22222222-2	Cliente Prueba Ltda	Av. Central 123	Santiago	215000.00	40850.00	255850.00	20E6F2C77634	ENVIADO	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<DTE version="1.0"><Documento ID="F33T21"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>116</Folio><FchEmis>2025-11-23</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>22222222-2</RUTRecep><RznSocRecep>Cliente Prueba Ltda</RznSocRecep><DirRecep>Av. Central 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>215000</MntNeto><IVA>40850</IVA><MntTotal>255850</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio de Desarrollo</NmbItem><QtyItem>1.00</QtyItem><PrcItem>200000.00</PrcItem><MontoItem>200000</MontoItem></Detalle><Detalle><NroLinDet>2</NroLinDet><NmbItem>Hosting Mensual</NmbItem><QtyItem>1.00</QtyItem><PrcItem>15000.00</PrcItem><MontoItem>15000</MontoItem></Detalle><TED version="1.0"><DD><RE>11111111-1</RE><TD>33</TD><F>116</F><FE>20251123</FE><RR>22222222-2</RR><RSR>CLIENTE PRUEBA LTDA</RSR><MNT>255850</MNT><IT1>Servicio de Desarrollo</IT1><TSTED>2025-11-23T02:55:25</TSTED></DD><FRMA algoritmo="SHA1withRSA">Pj3bewIswjBcLvEdpBTBmHc5RMUgH/ur5/8qFm7No0w0MRsRXOmehANJ1J1EO1VV/bNpurj63aUO9QrMrtLBpD6pRFvDonHXRqPz1Td8RH4wRfRp7lkbD2O2lVKanrWxDLgBIGeGbpLK+cuiqUTh0muamGoswLiaEJOck7Ti3a9SFUwNyI/K2phR+08tGrZk+y47UlmDGFgv8f4N/NWb/N5S+YtnpSBQXRo8ciWCd012PSUlRYyKKhni6uNlGIcKs7/qUug+uaw84OEAZbOY0IdDX4S1gTHU3Bj2UedSkiSBSrsmpLAb7YxR04LPxUu3NwmByHch7kxnp4G/FqUgqQ==</FRMA></TED><TmstFirma>2025-11-23T02:55:25</TmstFirma></Documento></DTE>	\N	\N
22	1	1	33	117	22222222-2	Cliente Prueba Ltda	Av. Central 123	Santiago	215000.00	40850.00	255850.00	BC7C38E63B26	ENVIADO	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<DTE version="1.0"><Documento ID="F33T22"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>117</Folio><FchEmis>2025-11-23</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>22222222-2</RUTRecep><RznSocRecep>Cliente Prueba Ltda</RznSocRecep><DirRecep>Av. Central 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>215000</MntNeto><IVA>40850</IVA><MntTotal>255850</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio de Desarrollo</NmbItem><QtyItem>1.00</QtyItem><PrcItem>200000.00</PrcItem><MontoItem>200000</MontoItem></Detalle><Detalle><NroLinDet>2</NroLinDet><NmbItem>Hosting Mensual</NmbItem><QtyItem>1.00</QtyItem><PrcItem>15000.00</PrcItem><MontoItem>15000</MontoItem></Detalle><TED version="1.0"><DD><RE>11111111-1</RE><TD>33</TD><F>117</F><FE>20251123</FE><RR>22222222-2</RR><RSR>CLIENTE PRUEBA LTDA</RSR><MNT>255850</MNT><IT1>Servicio de Desarrollo</IT1><TSTED>2025-11-23T19:06:32</TSTED></DD><FRMA algoritmo="SHA1withRSA">JQdTJNy+HqPr7muY0zOk16ygw4yx7pZP1FVFxcQ84Fdn0r9SIodSI8ErvbYRlJneZiKrYKADW0feqvrukHdPHeKY16pprc7IsQX/ZDDZRRSLdUZLQ16jnA1P1Wj1de8h32u6fdclL9NTXEyKqkSVIDIsykjOMskPJ5FGcivg411rDV/9MaZ/Q/I6y5AxYM6y5HfB/RocQSBQQhdq7Bca6VRZCKdYpB4IVHqNiFHBph1zczMgGV8MBsAi9hgbBfiqV0qsTfQELLPC2stY3aSSC5AW0kPUpAFXUev8b1JF/zRCGkBWp1f1XWDb0eVe91wbPIOKyybLFk0oZqJ0VyA+UA==</FRMA></TED><TmstFirma>2025-11-23T19:06:32</TmstFirma></Documento></DTE>	\N	\N
23	1	1	33	118	22222222-2	Cliente Prueba Ltda	Av. Central 123	Santiago	215000.00	40850.00	255850.00	DUMMY-AD5B39D11B	ENVIADO	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<DTE version="1.0"><Documento ID="F33T23"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>118</Folio><FchEmis>2025-11-23</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>22222222-2</RUTRecep><RznSocRecep>Cliente Prueba Ltda</RznSocRecep><DirRecep>Av. Central 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>215000</MntNeto><IVA>40850</IVA><MntTotal>255850</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio de Desarrollo</NmbItem><QtyItem>1.00</QtyItem><PrcItem>200000.00</PrcItem><MontoItem>200000</MontoItem></Detalle><Detalle><NroLinDet>2</NroLinDet><NmbItem>Hosting Mensual</NmbItem><QtyItem>1.00</QtyItem><PrcItem>15000.00</PrcItem><MontoItem>15000</MontoItem></Detalle><TED version="1.0"><DD><RE>11111111-1</RE><TD>33</TD><F>118</F><FE>20251123</FE><RR>22222222-2</RR><RSR>CLIENTE PRUEBA LTDA</RSR><MNT>255850</MNT><IT1>Servicio de Desarrollo</IT1><TSTED>2025-11-23T23:13:32</TSTED></DD><FRMA algoritmo="SHA1withRSA">f8BKegDKbH5KxiW4teTu2trP0XmQJjl4Mjf1JZf88plyRAtksrAoEjUPBZp1rfbXV7V+JtVYryinIAWpJMFlVP/k+dAlfHleh28f5z78oxl/IdwuW6WRScUXOstyYGGIf1tIY9dUN7w2fYjjOEZKtY2hBtZ91xUX5k0U9gBRh7VF81S2fL4r2qjGLqExGapuxwU3ojhwtT7vWYq7ohNfWurBNPFr5oDmrzS9Z4NA2CMUHHYqJRFWhIFtr/snUXzHurG4un3rhOSxfHNzz4lQTQswtjtAKPP5GlKxEz5vY4yG6u8VIjdz97o+Hfswxxvo/HJOGcudMRVCRWpTUK1eCw==</FRMA></TED><TmstFirma>2025-11-23T23:13:32</TmstFirma></Documento></DTE>	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<EnvioDTE xmlns:ds="http://www.w3.org/2000/09/xmldsig#" version="1.0" xmlns="http://www.sii.cl/SiiDte"><SetDTE ID="SetDoc_20251123231332"><Caratula version="1.0"><RutEmisor>11111111-1</RutEmisor><RutEnvia>11111111-1</RutEnvia><RutReceptor>60803000-K</RutReceptor><FchResol>2020-01-01</FchResol><NroResol>0</NroResol><TmstFirmaEnv>2025-11-23T23:13:32</TmstFirmaEnv><SubTotDTE><TpoDTE>33</TpoDTE><NroDte>1</NroDte></SubTotDTE></Caratula><DTE version="1.0"><Documento ID="F33T23"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>118</Folio><FchEmis>2025-11-23</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>22222222-2</RUTRecep><RznSocRecep>Cliente Prueba Ltda</RznSocRecep><DirRecep>Av. Central 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>215000</MntNeto><IVA>40850</IVA><MntTotal>255850</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio de Desarrollo</NmbItem><QtyItem>1.00</QtyItem><PrcItem>200000.00</PrcItem><MontoItem>200000</MontoItem></Detalle><Detalle><NroLinDet>2</NroLinDet><NmbItem>Hosting Mensual</NmbItem><QtyItem>1.00</QtyItem><PrcItem>15000.00</PrcItem><MontoItem>15000</MontoItem></Detalle><TED version="1.0"><DD><RE>11111111-1</RE><TD>33</TD><F>118</F><FE>20251123</FE><RR>22222222-2</RR><RSR>CLIENTE PRUEBA LTDA</RSR><MNT>255850</MNT><IT1>Servicio de Desarrollo</IT1><TSTED>2025-11-23T23:13:32</TSTED></DD><FRMA algoritmo="SHA1withRSA">f8BKegDKbH5KxiW4teTu2trP0XmQJjl4Mjf1JZf88plyRAtksrAoEjUPBZp1rfbXV7V+JtVYryinIAWpJMFlVP/k+dAlfHleh28f5z78oxl/IdwuW6WRScUXOstyYGGIf1tIY9dUN7w2fYjjOEZKtY2hBtZ91xUX5k0U9gBRh7VF81S2fL4r2qjGLqExGapuxwU3ojhwtT7vWYq7ohNfWurBNPFr5oDmrzS9Z4NA2CMUHHYqJRFWhIFtr/snUXzHurG4un3rhOSxfHNzz4lQTQswtjtAKPP5GlKxEz5vY4yG6u8VIjdz97o+Hfswxxvo/HJOGcudMRVCRWpTUK1eCw==</FRMA></TED><TmstFirma>2025-11-23T23:13:32</TmstFirma></Documento></DTE></SetDTE><ds:Signature><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" /><ds:Reference URI=""><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" /><ds:DigestValue>DIGEST_PLACEHOLDER</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>SIGNATURE_PLACEHOLDER</ds:SignatureValue><ds:KeyInfo><ds:KeyName>CERT_PLACEHOLDER</ds:KeyName></ds:KeyInfo></ds:Signature></EnvioDTE>
25	1	1	33	120	11.111.111-1	Cliente Prueba	Av. Chile 123	Santiago	1000.00	190.00	1190.00	DUMMY-DD3C2E0979	ENVIADO	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<DTE xmlns="http://www.sii.cl/SiiDte" version="1.0"><Documento ID="F33T25"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>120</Folio><FchEmis>2025-11-26</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>11.111.111-1</RUTRecep><RznSocRecep>Cliente Prueba</RznSocRecep><DirRecep>Av. Chile 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>1000</MntNeto><IVA>190</IVA><MntTotal>1190</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio X</NmbItem><QtyItem>1.00</QtyItem><PrcItem>1000.00</PrcItem><MontoItem>1000</MontoItem></Detalle><TED version="1.0"><DD><RE>11111111-1</RE><TD>33</TD><F>120</F><FE>20251126</FE><RR>11.111.111-1</RR><RSR>CLIENTE PRUEBA</RSR><MNT>1190</MNT><IT1>Servicio X</IT1><TSTED>2025-11-26T01:14:59</TSTED></DD><FRMA algoritmo="SHA1withRSA">B3us6ztsR7Ck1FZqsvmc9mCvlu8kqDWs8Dn1tvfmSbR11k9EqwZAbUoMnMG+2UqeBjJl7uvpKndPQEPZx3aLvjf6PowPx5FM3bks7H41HD7sUC9hVN4lKnhqEHcW3Sn3w+CiBSSTEoNZaOyKnmM75uB5vM7LAzblB2dZM8g/DdnEIsjGbYC+IKxgO/VNpNrK0DVQZLAQkT3+BQwY3Up5ZaiMc236eGx+2OPOBX8lTxwKtJ2Da/AylMp3rRlH9VbxGe+2OFRu4el2JrZOznc/cSLBwOgiZ4YSaEWLsbPOR6t//vmUmCQUds43PVD/1k8e5WprpYkbKss3RxfhOwzxdQ==</FRMA></TED><TmstFirma>2025-11-26T01:14:59</TmstFirma></Documento></DTE>	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<EnvioDTE xmlns="http://www.sii.cl/SiiDte" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" version="1.0" xmlns="http://www.sii.cl/SiiDte"><SetDTE ID="SetDoc_20251126011459"><Caratula version="1.0"><RutEmisor>11111111-1</RutEmisor><RutEnvia>11111111-1</RutEnvia><RutReceptor>60803000-K</RutReceptor><FchResol>2020-01-01</FchResol><NroResol>0</NroResol><TmstFirmaEnv>2025-11-26T01:14:59</TmstFirmaEnv><SubTotDTE><TpoDTE>33</TpoDTE><NroDte>1</NroDte></SubTotDTE></Caratula><DTE version="1.0"><Documento ID="F33T25"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>120</Folio><FchEmis>2025-11-26</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>11.111.111-1</RUTRecep><RznSocRecep>Cliente Prueba</RznSocRecep><DirRecep>Av. Chile 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>1000</MntNeto><IVA>190</IVA><MntTotal>1190</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio X</NmbItem><QtyItem>1.00</QtyItem><PrcItem>1000.00</PrcItem><MontoItem>1000</MontoItem></Detalle><TED version="1.0"><DD><RE>11111111-1</RE><TD>33</TD><F>120</F><FE>20251126</FE><RR>11.111.111-1</RR><RSR>CLIENTE PRUEBA</RSR><MNT>1190</MNT><IT1>Servicio X</IT1><TSTED>2025-11-26T01:14:59</TSTED></DD><FRMA algoritmo="SHA1withRSA">B3us6ztsR7Ck1FZqsvmc9mCvlu8kqDWs8Dn1tvfmSbR11k9EqwZAbUoMnMG+2UqeBjJl7uvpKndPQEPZx3aLvjf6PowPx5FM3bks7H41HD7sUC9hVN4lKnhqEHcW3Sn3w+CiBSSTEoNZaOyKnmM75uB5vM7LAzblB2dZM8g/DdnEIsjGbYC+IKxgO/VNpNrK0DVQZLAQkT3+BQwY3Up5ZaiMc236eGx+2OPOBX8lTxwKtJ2Da/AylMp3rRlH9VbxGe+2OFRu4el2JrZOznc/cSLBwOgiZ4YSaEWLsbPOR6t//vmUmCQUds43PVD/1k8e5WprpYkbKss3RxfhOwzxdQ==</FRMA></TED><TmstFirma>2025-11-26T01:14:59</TmstFirma></Documento></DTE></SetDTE><ds:Signature><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" /><ds:Reference URI=""><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" /><ds:DigestValue>DIGEST_PLACEHOLDER</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>SIGNATURE_PLACEHOLDER</ds:SignatureValue><ds:KeyInfo><ds:KeyName>CERT_PLACEHOLDER</ds:KeyName></ds:KeyInfo></ds:Signature></EnvioDTE>
24	1	1	33	119	11.111.111-1	Cliente Prueba	Av. Chile 123	Santiago	1000.00	190.00	1190.00	\N	ERROR	XML DTE inválido según schema SII	<?xml version='1.0' encoding='iso-8859-1'?>\n<DTE version="1.0"><Documento ID="F33T24"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>119</Folio><FchEmis>2025-11-26</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>11.111.111-1</RUTRecep><RznSocRecep>Cliente Prueba</RznSocRecep><DirRecep>Av. Chile 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>1000</MntNeto><IVA>190</IVA><MntTotal>1190</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio X</NmbItem><QtyItem>1.00</QtyItem><PrcItem>1000.00</PrcItem><MontoItem>1000</MontoItem></Detalle><TED version="1.0"><DD><RE>11111111-1</RE><TD>33</TD><F>119</F><FE>20251126</FE><RR>11.111.111-1</RR><RSR>CLIENTE PRUEBA</RSR><MNT>1190</MNT><IT1>Servicio X</IT1><TSTED>2025-11-26T00:56:17</TSTED></DD><FRMA algoritmo="SHA1withRSA">d758UZh+nkGJwP0vd9eVJ/Qtp+iaFPrPTSlb9+hhFxIbiQSsrNPLyVy7pOPpkabEtzpbeF7r00urUwsmIx/3WHMU2iZkq9RxiMrm0sQWy+YH2p+Fz8CRjZrIaDf8TeM+ayBp38fZm+ZI/vQJ8c4YwGQSqlHyfjj1WuB6EA27BLFY92V7uDGOFWRz/HMfNk0/kMESutFKv72nJBAqvO81UWJPXfDcMqYE4HO1TS/2Txl9IAz+k/zbZP7tt3hWDuS4Mpbmst8cZN6HNENZ3ftI8ztjNvzcN6UrjTY+xs2vN9Kx2ujxvvd6tDdmsrdKnLmBk/UoynT0KaZ4i82WKNTgEw==</FRMA></TED><TmstFirma>2025-11-26T00:56:17</TmstFirma></Documento></DTE>	\N	\N
26	1	1	33	121	11.111.111-1	Cliente Prueba	Av. Chile 123	Santiago	1000.00	190.00	1190.00	DUMMY-C940FD1D5C	ENVIADO	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<DTE xmlns="http://www.sii.cl/SiiDte" version="1.0"><Documento ID="F33T26"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>121</Folio><FchEmis>2025-11-26</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>11.111.111-1</RUTRecep><RznSocRecep>Cliente Prueba</RznSocRecep><DirRecep>Av. Chile 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>1000</MntNeto><IVA>190</IVA><MntTotal>1190</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio X</NmbItem><QtyItem>1.00</QtyItem><PrcItem>1000.00</PrcItem><MontoItem>1000</MontoItem></Detalle><TED version="1.0"><DD><RE>11111111-1</RE><TD>33</TD><F>121</F><FE>20251126</FE><RR>11.111.111-1</RR><RSR>CLIENTE PRUEBA</RSR><MNT>1190</MNT><IT1>Servicio X</IT1><TSTED>2025-11-26T01:26:30</TSTED></DD><FRMA algoritmo="SHA1withRSA">OodHm/Zy3GP8e16hfz+rFedykD4c79uAzncLMwk9gGr2YlEkJZaE+lZ6MgRetfEAx/qOsefn6OCYkPoOdIw0qRtfLofrEiG5aggO7vY48EFcyBWUDpxmtEk0IiZe+H6JuxWeIEmYxVefYuGKRKQaE4fcFGTnDosrcO86cOxAeK6fe9+051qK4Irj9nkN45xcrHAFbjsUQIQx2dVvvYrnTknftEoXOeCDwqVeXl1Tb+fGSoDPWRTtgglLZy50HQ0+5BDj/8H5n4JwFhRN5KeX260A3B5R+k6ENnh5qx2EUg5CcGuxG2HsJfRtXU0tNy6Hi12xR0uc1XDcpIIEAPfLpg==</FRMA></TED><TmstFirma>2025-11-26T01:26:30</TmstFirma></Documento></DTE>	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<EnvioDTE xmlns="http://www.sii.cl/SiiDte" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" xsi:schemaLocation="http://www.sii.cl/SiiDte EnvioDTE_v10.xsd"><SetDTE ID="SetDoc_20251126012631"><Caratula version="1.0"><RutEmisor>11111111-1</RutEmisor><RutEnvia>11111111-1</RutEnvia><RutReceptor>60803000-K</RutReceptor><FchResol>2020-01-01</FchResol><NroResol>0</NroResol><TmstFirmaEnv>2025-11-26T01:26:31</TmstFirmaEnv><SubTotDTE><TpoDTE>33</TpoDTE><NroDTE>1</NroDTE></SubTotDTE></Caratula><DTE version="1.0"><Documento ID="F33T26"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>121</Folio><FchEmis>2025-11-26</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>11.111.111-1</RUTRecep><RznSocRecep>Cliente Prueba</RznSocRecep><DirRecep>Av. Chile 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>1000</MntNeto><IVA>190</IVA><MntTotal>1190</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio X</NmbItem><QtyItem>1.00</QtyItem><PrcItem>1000.00</PrcItem><MontoItem>1000</MontoItem></Detalle><TED version="1.0"><DD><RE>11111111-1</RE><TD>33</TD><F>121</F><FE>20251126</FE><RR>11.111.111-1</RR><RSR>CLIENTE PRUEBA</RSR><MNT>1190</MNT><IT1>Servicio X</IT1><TSTED>2025-11-26T01:26:30</TSTED></DD><FRMA algoritmo="SHA1withRSA">OodHm/Zy3GP8e16hfz+rFedykD4c79uAzncLMwk9gGr2YlEkJZaE+lZ6MgRetfEAx/qOsefn6OCYkPoOdIw0qRtfLofrEiG5aggO7vY48EFcyBWUDpxmtEk0IiZe+H6JuxWeIEmYxVefYuGKRKQaE4fcFGTnDosrcO86cOxAeK6fe9+051qK4Irj9nkN45xcrHAFbjsUQIQx2dVvvYrnTknftEoXOeCDwqVeXl1Tb+fGSoDPWRTtgglLZy50HQ0+5BDj/8H5n4JwFhRN5KeX260A3B5R+k6ENnh5qx2EUg5CcGuxG2HsJfRtXU0tNy6Hi12xR0uc1XDcpIIEAPfLpg==</FRMA></TED><TmstFirma>2025-11-26T01:26:30</TmstFirma></Documento></DTE></SetDTE><ds:Signature><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" /><ds:Reference URI=""><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" /><ds:DigestValue>DIGEST_PLACEHOLDER</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>SIGNATURE_PLACEHOLDER</ds:SignatureValue><ds:KeyInfo><ds:KeyName>CERT_PLACEHOLDER</ds:KeyName></ds:KeyInfo></ds:Signature></EnvioDTE>
27	1	1	33	122	11.111.111-1	Cliente Prueba	Av. Chile 123	Santiago	1000.00	190.00	1190.00	DUMMY-9A1D4CE455	ENVIADO	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<DTE xmlns="http://www.sii.cl/SiiDte" version="1.0"><Documento ID="F33T27"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>122</Folio><FchEmis>2025-11-26</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>11.111.111-1</RUTRecep><RznSocRecep>Cliente Prueba</RznSocRecep><DirRecep>Av. Chile 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>1000</MntNeto><IVA>190</IVA><MntTotal>1190</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio X</NmbItem><QtyItem>1.00</QtyItem><PrcItem>1000.00</PrcItem><MontoItem>1000</MontoItem></Detalle><TED version="1.0"><DD><RE>11111111-1</RE><TD>33</TD><F>122</F><FE>20251126</FE><RR>11.111.111-1</RR><RSR>CLIENTE PRUEBA</RSR><MNT>1190</MNT><IT1>Servicio X</IT1><TSTED>2025-11-26T01:31:30</TSTED></DD><FRMA algoritmo="SHA1withRSA">Qko41fYYXhecAtx6G9CNo5zzf6/nRXANgISFFlkDrI6s08HRTMyZ5qWpBITcKgm0VOc5rGxu7rhcysAwFowE+62dB6iz2e0nDbaF6DDiMp8DXxV6WsKSh7EFRCSVS4uPahH6dOpHB0PnC9myOTlhYiXG5YdSk+L8BvfMRrrkUcpNc4oHRzQ7beO5ccPJVkSyO7AdSuJD8FUWGfE/XgwddNd2YFNlXXfaGfGsKnZiTV9IVNStPuIsrhZCfzj++AKnVuzGEKe356E4+AC4wAf6od4RACS7ryXO7Z7k+Lyp8hoYNiz3dDAlyWcYDg7QmT7o8COJFfJF+J4/+FgDJq41+Q==</FRMA></TED><TmstFirma>2025-11-26T01:31:30</TmstFirma></Documento></DTE>	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<EnvioDTE xmlns="http://www.sii.cl/SiiDte" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" xsi:schemaLocation="http://www.sii.cl/SiiDte EnvioDTE_v10.xsd"><SetDTE ID="SetDoc_20251126013130"><Caratula version="1.0"><RutEmisor>11111111-1</RutEmisor><RutEnvia>11111111-1</RutEnvia><RutReceptor>60803000-K</RutReceptor><FchResol>2020-01-01</FchResol><NroResol>0</NroResol><TmstFirmaEnv>2025-11-26T01:31:30</TmstFirmaEnv><SubTotDTE><TpoDTE>33</TpoDTE><NroDTE>1</NroDTE></SubTotDTE></Caratula><DTE version="1.0"><Documento ID="F33T27"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>122</Folio><FchEmis>2025-11-26</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>11.111.111-1</RUTRecep><RznSocRecep>Cliente Prueba</RznSocRecep><DirRecep>Av. Chile 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>1000</MntNeto><IVA>190</IVA><MntTotal>1190</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio X</NmbItem><QtyItem>1.00</QtyItem><PrcItem>1000.00</PrcItem><MontoItem>1000</MontoItem></Detalle><TED version="1.0"><DD><RE>11111111-1</RE><TD>33</TD><F>122</F><FE>20251126</FE><RR>11.111.111-1</RR><RSR>CLIENTE PRUEBA</RSR><MNT>1190</MNT><IT1>Servicio X</IT1><TSTED>2025-11-26T01:31:30</TSTED></DD><FRMA algoritmo="SHA1withRSA">Qko41fYYXhecAtx6G9CNo5zzf6/nRXANgISFFlkDrI6s08HRTMyZ5qWpBITcKgm0VOc5rGxu7rhcysAwFowE+62dB6iz2e0nDbaF6DDiMp8DXxV6WsKSh7EFRCSVS4uPahH6dOpHB0PnC9myOTlhYiXG5YdSk+L8BvfMRrrkUcpNc4oHRzQ7beO5ccPJVkSyO7AdSuJD8FUWGfE/XgwddNd2YFNlXXfaGfGsKnZiTV9IVNStPuIsrhZCfzj++AKnVuzGEKe356E4+AC4wAf6od4RACS7ryXO7Z7k+Lyp8hoYNiz3dDAlyWcYDg7QmT7o8COJFfJF+J4/+FgDJq41+Q==</FRMA></TED><TmstFirma>2025-11-26T01:31:30</TmstFirma></Documento></DTE></SetDTE><ds:Signature><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" /><ds:Reference URI=""><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" /><ds:DigestValue>DIGEST_PLACEHOLDER</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>SIGNATURE_PLACEHOLDER</ds:SignatureValue><ds:KeyInfo><ds:KeyName>CERT_PLACEHOLDER</ds:KeyName></ds:KeyInfo></ds:Signature></EnvioDTE>
28	1	1	33	123	11.111.111-1	Cliente Prueba	Av. Chile 123	Santiago	1000.00	190.00	1190.00	DUMMY-3FE0BE7A13	ENVIADO	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<DTE xmlns="http://www.sii.cl/SiiDte" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" version="1.0"><Documento ID="F33T28"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>123</Folio><FchEmis>2025-11-26</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><Acteco>000000</Acteco><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>11111111-1</RUTRecep><RznSocRecep>Cliente Prueba</RznSocRecep><DirRecep>Av. Chile 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>1000</MntNeto><IVA>190</IVA><MntTotal>1190</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio X</NmbItem><QtyItem>1.00</QtyItem><PrcItem>1000.00</PrcItem><MontoItem>1000</MontoItem></Detalle><TED version="1.0"><DD><RE>11111111-1</RE><TD>33</TD><F>123</F><FE>2025-11-26</FE><RR>11111111-1</RR><RSR>CLIENTE PRUEBA</RSR><MNT>1190</MNT><IT1>Servicio X</IT1><TSTED>2025-11-26T01:39:05</TSTED></DD><FRMT algoritmo="SHA1withRSA">JloUSaX3W4FJl2UiZ/ASe7uT+Js8ywAIQRdF2zshdsyY9tWLtBKE/2wniyro0sX/4eyBED+3Gje0NhP0c9EkPE7q5gw6kV40cg5joyxeTFqzN514vkKYWpKtGjrQ1BU3QezC8l4BxaDXXW8Z7/rCDraN+VVxIWXu40o/KmidLbsUDLvXzFme2FndJ5tTNq1TgYF/Srb/TEcItt0Mcn2yUUYYcdmXFyRaqarFsaDa8PSWKVMYZCOTnRtfuN9UVqAiTnRhAuDe+qySpf2xlbc/SELJu0lPasTfFyacQfKaSUQicDzMmhDvbnmQBHeL/phhmtAdGFhb0a71qqdXDp3Nnw==</FRMT></TED><TmstFirma>2025-11-26T01:39:06</TmstFirma></Documento><ds:Signature><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" /><ds:Reference URI=""><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" /><ds:DigestValue>AA==</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>AA==</ds:SignatureValue><ds:KeyInfo><ds:KeyValue /></ds:KeyInfo></ds:Signature></DTE>	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<EnvioDTE xmlns="http://www.sii.cl/SiiDte" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" xsi:schemaLocation="http://www.sii.cl/SiiDte EnvioDTE_v10.xsd"><SetDTE ID="SetDoc_20251126013906"><Caratula version="1.0"><RutEmisor>11111111-1</RutEmisor><RutEnvia>11111111-1</RutEnvia><RutReceptor>60803000-K</RutReceptor><FchResol>2020-01-01</FchResol><NroResol>0</NroResol><TmstFirmaEnv>2025-11-26T01:39:06</TmstFirmaEnv><SubTotDTE><TpoDTE>33</TpoDTE><NroDTE>1</NroDTE></SubTotDTE></Caratula><DTE version="1.0"><Documento ID="F33T28"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>123</Folio><FchEmis>2025-11-26</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><Acteco>000000</Acteco><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>11111111-1</RUTRecep><RznSocRecep>Cliente Prueba</RznSocRecep><DirRecep>Av. Chile 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>1000</MntNeto><IVA>190</IVA><MntTotal>1190</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio X</NmbItem><QtyItem>1.00</QtyItem><PrcItem>1000.00</PrcItem><MontoItem>1000</MontoItem></Detalle><TED version="1.0"><DD><RE>11111111-1</RE><TD>33</TD><F>123</F><FE>2025-11-26</FE><RR>11111111-1</RR><RSR>CLIENTE PRUEBA</RSR><MNT>1190</MNT><IT1>Servicio X</IT1><TSTED>2025-11-26T01:39:05</TSTED></DD><FRMT algoritmo="SHA1withRSA">JloUSaX3W4FJl2UiZ/ASe7uT+Js8ywAIQRdF2zshdsyY9tWLtBKE/2wniyro0sX/4eyBED+3Gje0NhP0c9EkPE7q5gw6kV40cg5joyxeTFqzN514vkKYWpKtGjrQ1BU3QezC8l4BxaDXXW8Z7/rCDraN+VVxIWXu40o/KmidLbsUDLvXzFme2FndJ5tTNq1TgYF/Srb/TEcItt0Mcn2yUUYYcdmXFyRaqarFsaDa8PSWKVMYZCOTnRtfuN9UVqAiTnRhAuDe+qySpf2xlbc/SELJu0lPasTfFyacQfKaSUQicDzMmhDvbnmQBHeL/phhmtAdGFhb0a71qqdXDp3Nnw==</FRMT></TED><TmstFirma>2025-11-26T01:39:06</TmstFirma></Documento><ds:Signature><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" /><ds:Reference URI=""><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" /><ds:DigestValue>AA==</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>AA==</ds:SignatureValue><ds:KeyInfo><ds:KeyValue /></ds:KeyInfo></ds:Signature></DTE></SetDTE><ds:Signature><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" /><ds:Reference URI=""><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" /><ds:DigestValue>DIGEST_PLACEHOLDER</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>SIGNATURE_PLACEHOLDER</ds:SignatureValue><ds:KeyInfo><ds:KeyName>CERT_PLACEHOLDER</ds:KeyName></ds:KeyInfo></ds:Signature></EnvioDTE>
29	1	1	33	124	11.111.111-1	Cliente Prueba	Av. Chile 123	Santiago	1000.00	190.00	1190.00	DUMMY-B65D800892	ENVIADO	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<DTE xmlns="http://www.sii.cl/SiiDte" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" version="1.0"><Documento ID="F33T29"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>124</Folio><FchEmis>2025-11-26</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><Acteco>000000</Acteco><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>11111111-1</RUTRecep><RznSocRecep>Cliente Prueba</RznSocRecep><DirRecep>Av. Chile 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>1000</MntNeto><IVA>190</IVA><MntTotal>1190</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio X</NmbItem><QtyItem>1.00</QtyItem><PrcItem>1000.00</PrcItem><MontoItem>1000</MontoItem></Detalle><TED version="1.0"><DD><RE>11111111-1</RE><TD>33</TD><F>124</F><FE>2025-11-26</FE><RR>11111111-1</RR><RSR>CLIENTE PRUEBA</RSR><MNT>1190</MNT><IT1>Servicio X</IT1><TSTED>2025-11-26T02:04:55</TSTED></DD><FRMT algoritmo="SHA1withRSA">a5c9qYcBjbJybG5UkKK+jQ80UMOZLZVKaLr1WWZtjXqDP37lJNmwoqZ1WB+RVefD8le9k4gS50KfUxwFzS9sQQre82ldTINt8RfBWytwm7tMRe/bXV30/mUp4W8D8JlFTh8gfuN2hSAp5ZzvL21OEIU2CLm/Tq5FGdeRv5wbJ/eKdnS5F2k3swrgMqsi2ymBcwk9O+O2bFNksZ2pxTWDvG9/YlcQeu1Z5b3VKn4eJS8XjiJ1O2UwcHYQTPf79+wmlIQfbwvHHKHKM2AVU8EkykOVKoPKfeVYcc/ua7ifiwFibn/qKBioUssiWU/ERdMyGKE4khFG0e5rOFmuBQJ00w==</FRMT></TED><TmstFirma>2025-11-26T02:04:55</TmstFirma></Documento><ds:Signature><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" /><ds:Reference URI=""><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" /><ds:DigestValue>AA==</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>AA==</ds:SignatureValue><ds:KeyInfo><ds:KeyValue /></ds:KeyInfo></ds:Signature></DTE>	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<EnvioDTE xmlns="http://www.sii.cl/SiiDte" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" xsi:schemaLocation="http://www.sii.cl/SiiDte EnvioDTE_v10.xsd"><SetDTE ID="SetDoc_20251126020455"><Caratula version="1.0"><RutEmisor>11111111-1</RutEmisor><RutEnvia>11111111-1</RutEnvia><RutReceptor>60803000-K</RutReceptor><FchResol>2020-01-01</FchResol><NroResol>0</NroResol><TmstFirmaEnv>2025-11-26T02:04:55</TmstFirmaEnv><SubTotDTE><TpoDTE>33</TpoDTE><NroDTE>1</NroDTE></SubTotDTE></Caratula><DTE version="1.0"><Documento ID="F33T29"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>124</Folio><FchEmis>2025-11-26</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><Acteco>000000</Acteco><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>11111111-1</RUTRecep><RznSocRecep>Cliente Prueba</RznSocRecep><DirRecep>Av. Chile 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>1000</MntNeto><IVA>190</IVA><MntTotal>1190</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio X</NmbItem><QtyItem>1.00</QtyItem><PrcItem>1000.00</PrcItem><MontoItem>1000</MontoItem></Detalle><TED version="1.0"><DD><RE>11111111-1</RE><TD>33</TD><F>124</F><FE>2025-11-26</FE><RR>11111111-1</RR><RSR>CLIENTE PRUEBA</RSR><MNT>1190</MNT><IT1>Servicio X</IT1><TSTED>2025-11-26T02:04:55</TSTED></DD><FRMT algoritmo="SHA1withRSA">a5c9qYcBjbJybG5UkKK+jQ80UMOZLZVKaLr1WWZtjXqDP37lJNmwoqZ1WB+RVefD8le9k4gS50KfUxwFzS9sQQre82ldTINt8RfBWytwm7tMRe/bXV30/mUp4W8D8JlFTh8gfuN2hSAp5ZzvL21OEIU2CLm/Tq5FGdeRv5wbJ/eKdnS5F2k3swrgMqsi2ymBcwk9O+O2bFNksZ2pxTWDvG9/YlcQeu1Z5b3VKn4eJS8XjiJ1O2UwcHYQTPf79+wmlIQfbwvHHKHKM2AVU8EkykOVKoPKfeVYcc/ua7ifiwFibn/qKBioUssiWU/ERdMyGKE4khFG0e5rOFmuBQJ00w==</FRMT></TED><TmstFirma>2025-11-26T02:04:55</TmstFirma></Documento><ds:Signature><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" /><ds:Reference URI=""><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" /><ds:DigestValue>AA==</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>AA==</ds:SignatureValue><ds:KeyInfo><ds:KeyValue /></ds:KeyInfo></ds:Signature></DTE></SetDTE><ds:Signature><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" /><ds:Reference URI=""><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" /><ds:DigestValue>DIGEST_PLACEHOLDER</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>SIGNATURE_PLACEHOLDER</ds:SignatureValue><ds:KeyInfo><ds:KeyName>CERT_PLACEHOLDER</ds:KeyName></ds:KeyInfo></ds:Signature></EnvioDTE>
30	1	1	33	125	11.111.111-1	Cliente Prueba	Av. Chile 123	Santiago	1000.00	190.00	1190.00	DUMMY-F110241399	ENVIADO	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<DTE xmlns="http://www.sii.cl/SiiDte" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" version="1.0"><Documento ID="F33T30"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>125</Folio><FchEmis>2025-11-29</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><Telefono>2222222</Telefono><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>11111111-1</RUTRecep><RznSocRecep>Cliente Prueba</RznSocRecep><DirRecep>Av. Chile 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>1000</MntNeto><IVA>190</IVA><MntTotal>1190</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio X</NmbItem><QtyItem>1.00</QtyItem><PrcItem>1000.00</PrcItem><MontoItem>1000</MontoItem></Detalle><TED version="1.0"><DD><RE>11111111-1</RE><TD>33</TD><F>125</F><FE>2025-11-29</FE><RR>11111111-1</RR><RSR>CLIENTE PRUEBA</RSR><MNT>1190</MNT><IT1>Servicio X</IT1><CAF version="1.0"><DA><RE>11111111-1</RE><RS>Mi Pyme SpA</RS><TD>33</TD><RNG><D>125</D><H>125</H></RNG><FA>2025-11-29</FA></DA><FRMA>AA==</FRMA></CAF><TSTED>2025-11-29T18:04:22</TSTED></DD><FRMT algoritmo="SHA1withRSA">QdthtAQh9F6YGm2K7e/+RlikOKdnlkWYT2VQEShiUU0ancyo+yM5F9aDI9zoXsnk7LF870e9BKT5ZmuQcULV2vxrlWIfiA3fwmrCbptngE/Jc9Dp9aEiGoSOgyRGn5LgOyy2GPtSelD71OwWG1eldhcYuLZqrrqoZ/hYitUzAPqAHrM/OqxhgioE8UF4SCEvX4t4tBEO0ojp3pZ+et1GYIOqUTBwIiGVBxwg2yy29W+Xlc67mFedeXMN+s5Tm44HQYtCChxps3EnP3cmqYEoc60aKbkHOoSMbiOcf08NB7wwxSon8SATuQrwo5RrcrS60MSgbmf7TosUOiLGHDGd9A==</FRMT></TED><TmstFirma>2025-11-29T18:04:22</TmstFirma></Documento><ds:Signature><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" /><ds:Reference URI=""><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" /><ds:DigestValue>AA==</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>AA==</ds:SignatureValue><ds:KeyInfo><ds:X509Data><ds:X509Certificate>AA==</ds:X509Certificate></ds:X509Data></ds:KeyInfo></ds:Signature></DTE>	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<EnvioDTE xmlns="http://www.sii.cl/SiiDte" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" xsi:schemaLocation="http://www.sii.cl/SiiDte EnvioDTE_v10.xsd"><SetDTE ID="SetDoc_20251129180423"><Caratula version="1.0"><RutEmisor>11111111-1</RutEmisor><RutEnvia>11111111-1</RutEnvia><RutReceptor>60803000-K</RutReceptor><FchResol>2020-01-01</FchResol><NroResol>0</NroResol><TmstFirmaEnv>2025-11-29T18:04:23</TmstFirmaEnv><SubTotDTE><TpoDTE>33</TpoDTE><NroDTE>1</NroDTE></SubTotDTE></Caratula><DTE version="1.0"><Documento ID="F33T30"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>125</Folio><FchEmis>2025-11-29</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><Telefono>2222222</Telefono><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>11111111-1</RUTRecep><RznSocRecep>Cliente Prueba</RznSocRecep><DirRecep>Av. Chile 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>1000</MntNeto><IVA>190</IVA><MntTotal>1190</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio X</NmbItem><QtyItem>1.00</QtyItem><PrcItem>1000.00</PrcItem><MontoItem>1000</MontoItem></Detalle><TED version="1.0"><DD><RE>11111111-1</RE><TD>33</TD><F>125</F><FE>2025-11-29</FE><RR>11111111-1</RR><RSR>CLIENTE PRUEBA</RSR><MNT>1190</MNT><IT1>Servicio X</IT1><CAF version="1.0"><DA><RE>11111111-1</RE><RS>Mi Pyme SpA</RS><TD>33</TD><RNG><D>125</D><H>125</H></RNG><FA>2025-11-29</FA></DA><FRMA>AA==</FRMA></CAF><TSTED>2025-11-29T18:04:22</TSTED></DD><FRMT algoritmo="SHA1withRSA">QdthtAQh9F6YGm2K7e/+RlikOKdnlkWYT2VQEShiUU0ancyo+yM5F9aDI9zoXsnk7LF870e9BKT5ZmuQcULV2vxrlWIfiA3fwmrCbptngE/Jc9Dp9aEiGoSOgyRGn5LgOyy2GPtSelD71OwWG1eldhcYuLZqrrqoZ/hYitUzAPqAHrM/OqxhgioE8UF4SCEvX4t4tBEO0ojp3pZ+et1GYIOqUTBwIiGVBxwg2yy29W+Xlc67mFedeXMN+s5Tm44HQYtCChxps3EnP3cmqYEoc60aKbkHOoSMbiOcf08NB7wwxSon8SATuQrwo5RrcrS60MSgbmf7TosUOiLGHDGd9A==</FRMT></TED><TmstFirma>2025-11-29T18:04:22</TmstFirma></Documento><ds:Signature><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" /><ds:Reference URI=""><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" /><ds:DigestValue>AA==</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>AA==</ds:SignatureValue><ds:KeyInfo><ds:X509Data><ds:X509Certificate>AA==</ds:X509Certificate></ds:X509Data></ds:KeyInfo></ds:Signature></DTE></SetDTE><ds:Signature><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" /><ds:Reference URI=""><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" /><ds:DigestValue>AA==</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>AA==</ds:SignatureValue><ds:KeyInfo><ds:X509Data><ds:X509Certificate>AA==</ds:X509Certificate></ds:X509Data></ds:KeyInfo></ds:Signature></EnvioDTE>
31	1	1	33	126	11.111.111-1	Cliente Prueba	Av. Chile 123	Santiago	1000.00	190.00	1190.00	DUMMY-0335C4D5B1	ENVIADO	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<DTE xmlns="http://www.sii.cl/SiiDte" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" version="1.0"><Documento ID="F33T31"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>126</Folio><FchEmis>2025-11-29</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><Acteco>123456</Acteco><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>11111111-1</RUTRecep><RznSocRecep>Cliente Prueba</RznSocRecep><DirRecep>Av. Chile 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>1000</MntNeto><IVA>190</IVA><MntTotal>1190</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio X</NmbItem><QtyItem>1.00</QtyItem><PrcItem>1000.00</PrcItem><MontoItem>1000</MontoItem></Detalle><TED version="1.0"><DD><RE>11111111-1</RE><TD>33</TD><F>126</F><FE>2025-11-29</FE><RR>11111111-1</RR><RSR>CLIENTE PRUEBA</RSR><MNT>1190</MNT><IT1>Servicio X</IT1><CAF version="1.0"><DA><RE>11111111-1</RE><RS>Mi Pyme SpA</RS><TD>33</TD><RNG><D>126</D><H>126</H></RNG><FA>2025-11-29</FA><RSAPK>AA==</RSAPK></DA><FRMA algoritmo="SHA1withRSA">AA==</FRMA></CAF><TSTED>2025-11-29T22:08:33</TSTED></DD><FRMT algoritmo="SHA1withRSA">LLikJyqDUb1KDR2uaw9Vd9Rt5CI/ppdCDRZmbr6iEnzhMYaHlLw1TQgpKga065i1d5RjcX/uy92fCNQKRTOKZeiZIeBqvE2AwZ/5OWdrPr7Wi/L6FjD+JFaR+GFnIa5Ug4XffDBhwaYlDQp5zcq5T7YDLq3TkApTUE/ozPEwKoevkKEwp2FUtIGC1d+RIxKo2uL9NderaiN47VC2P8Tt/vg11gW7SoNtGRXOn60vYB1wfX/KxjfdHEtEpasOFgg4o1V+pNZJiFy/77535x446w6M0PF93PhYQKVKMDgbo0wiAhhtP+lLEaNMnsCoO8VauR8Nat1CVPoNnZPwBi58lg==</FRMT></TED><TmstFirma>2025-11-29T22:08:33</TmstFirma></Documento><ds:Signature><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sh1" /><ds:Reference URI=""><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" /><ds:DigestValue>AA==</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>AA==</ds:SignatureValue><ds:KeyInfo><ds:KeyValue><ds:RSAKeyValue><ds:Modulus>AA==</ds:Modulus><ds:Exponent>AA==</ds:Exponent></ds:RSAKeyValue></ds:KeyValue></ds:KeyInfo></ds:Signature></DTE>	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<EnvioDTE xmlns="http://www.sii.cl/SiiDte" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" xsi:schemaLocation="http://www.sii.cl/SiiDte EnvioDTE_v10.xsd"><SetDTE ID="SetDoc_20251129220834"><Caratula version="1.0"><RutEmisor>11111111-1</RutEmisor><RutEnvia>11111111-1</RutEnvia><RutReceptor>60803000-K</RutReceptor><FchResol>2020-01-01</FchResol><NroResol>0</NroResol><TmstFirmaEnv>2025-11-29T22:08:34</TmstFirmaEnv><SubTotDTE><TpoDTE>33</TpoDTE><NroDTE>1</NroDTE></SubTotDTE></Caratula><DTE version="1.0"><Documento ID="F33T31"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>126</Folio><FchEmis>2025-11-29</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><Acteco>123456</Acteco><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>11111111-1</RUTRecep><RznSocRecep>Cliente Prueba</RznSocRecep><DirRecep>Av. Chile 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>1000</MntNeto><IVA>190</IVA><MntTotal>1190</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio X</NmbItem><QtyItem>1.00</QtyItem><PrcItem>1000.00</PrcItem><MontoItem>1000</MontoItem></Detalle><TED version="1.0"><DD><RE>11111111-1</RE><TD>33</TD><F>126</F><FE>2025-11-29</FE><RR>11111111-1</RR><RSR>CLIENTE PRUEBA</RSR><MNT>1190</MNT><IT1>Servicio X</IT1><CAF version="1.0"><DA><RE>11111111-1</RE><RS>Mi Pyme SpA</RS><TD>33</TD><RNG><D>126</D><H>126</H></RNG><FA>2025-11-29</FA><RSAPK>AA==</RSAPK></DA><FRMA algoritmo="SHA1withRSA">AA==</FRMA></CAF><TSTED>2025-11-29T22:08:33</TSTED></DD><FRMT algoritmo="SHA1withRSA">LLikJyqDUb1KDR2uaw9Vd9Rt5CI/ppdCDRZmbr6iEnzhMYaHlLw1TQgpKga065i1d5RjcX/uy92fCNQKRTOKZeiZIeBqvE2AwZ/5OWdrPr7Wi/L6FjD+JFaR+GFnIa5Ug4XffDBhwaYlDQp5zcq5T7YDLq3TkApTUE/ozPEwKoevkKEwp2FUtIGC1d+RIxKo2uL9NderaiN47VC2P8Tt/vg11gW7SoNtGRXOn60vYB1wfX/KxjfdHEtEpasOFgg4o1V+pNZJiFy/77535x446w6M0PF93PhYQKVKMDgbo0wiAhhtP+lLEaNMnsCoO8VauR8Nat1CVPoNnZPwBi58lg==</FRMT></TED><TmstFirma>2025-11-29T22:08:33</TmstFirma></Documento><ds:Signature><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sh1" /><ds:Reference URI=""><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" /><ds:DigestValue>AA==</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>AA==</ds:SignatureValue><ds:KeyInfo><ds:KeyValue><ds:RSAKeyValue><ds:Modulus>AA==</ds:Modulus><ds:Exponent>AA==</ds:Exponent></ds:RSAKeyValue></ds:KeyValue></ds:KeyInfo></ds:Signature></DTE></SetDTE><ds:Signature><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" /><ds:Reference URI=""><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" /><ds:DigestValue>AA==</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>AA==</ds:SignatureValue><ds:KeyInfo><ds:X509Data><ds:X509Certificate>AA==</ds:X509Certificate></ds:X509Data></ds:KeyInfo></ds:Signature></EnvioDTE>
32	1	1	33	127	11.111.111-1	Cliente Prueba	Av. Chile 123	Santiago	1000.00	190.00	1190.00	DUMMY-41825DA347	ENVIADO	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<DTE xmlns="http://www.sii.cl/SiiDte" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" version="1.0"><Documento ID="F33T32"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>127</Folio><FchEmis>2025-11-29</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><Acteco>123456</Acteco><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>11111111-1</RUTRecep><RznSocRecep>Cliente Prueba</RznSocRecep><DirRecep>Av. Chile 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>1000</MntNeto><IVA>190</IVA><MntTotal>1190</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio X</NmbItem><QtyItem>1.00</QtyItem><PrcItem>1000.00</PrcItem><MontoItem>1000</MontoItem></Detalle><TED version="1.0"><DD><RE>11111111-1</RE><TD>33</TD><F>127</F><FE>2025-11-29</FE><RR>11111111-1</RR><RSR>CLIENTE PRUEBA</RSR><MNT>1190</MNT><IT1>Servicio X</IT1><CAF version="1.0"><DA><RE>11111111-1</RE><RS>Mi Pyme SpA</RS><TD>33</TD><RNG><D>127</D><H>127</H></RNG><FA>2025-11-29</FA><RSAPK><M>AA==</M><E>AA==</E></RSAPK><IDK>FAKE-IDK</IDK></DA><FRMA algoritmo="SHA1withRSA">AA==</FRMA></CAF><TSTED>2025-11-29T22:45:51</TSTED></DD><FRMT algoritmo="SHA1withRSA">cStFGMVhorMMA3QiKS35A/jtQHiuKXZ+PFFOyD47tcvs8QFR02MxfLt2Pbm0MA9YwS0gQxjy2utR1X1YZVVDPMYR3/IFl++m0Ia2SoXUvW4mX7OpSlI+GZdB6yGwkJ7SrJ6Aj+qTu21Rso8SWQIS6mi7DA7gH/ONp3GFkHttkrIiMrXC+ZbV5IC/xuTYNp1lG74gZgv0OKFIx5801FRuKmCHQuEMIXyQUyjdw8MuuTsvpWMJB9UaQw+vjhQYvRT+XRvSDjxbHq7hBK/pBqMiANxXAERGNI02OO2Cv4DuuBqmC5vM3nCLwbJqYYVqd4nK4waLURu1TIzYOVS3Dui5IQ==</FRMT></TED><TmstFirma>2025-11-29T22:45:51</TmstFirma></Documento><ds:Signature><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" /><ds:Reference URI=""><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" /><ds:DigestValue>AA==</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>AA==</ds:SignatureValue><ds:KeyInfo><ds:X509Data><ds:X509Certificate>AA==</ds:X509Certificate></ds:X509Data></ds:KeyInfo></ds:Signature></DTE>	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<EnvioDTE xmlns="http://www.sii.cl/SiiDte" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" xsi:schemaLocation="http://www.sii.cl/SiiDte EnvioDTE_v10.xsd"><SetDTE ID="SetDoc_20251129224551"><Caratula version="1.0"><RutEmisor>11111111-1</RutEmisor><RutEnvia>11111111-1</RutEnvia><RutReceptor>60803000-K</RutReceptor><FchResol>2020-01-01</FchResol><NroResol>0</NroResol><TmstFirmaEnv>2025-11-29T22:45:51</TmstFirmaEnv><SubTotDTE><TpoDTE>33</TpoDTE><NroDTE>1</NroDTE></SubTotDTE></Caratula><DTE version="1.0"><Documento ID="F33T32"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>127</Folio><FchEmis>2025-11-29</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><Acteco>123456</Acteco><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>11111111-1</RUTRecep><RznSocRecep>Cliente Prueba</RznSocRecep><DirRecep>Av. Chile 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>1000</MntNeto><IVA>190</IVA><MntTotal>1190</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio X</NmbItem><QtyItem>1.00</QtyItem><PrcItem>1000.00</PrcItem><MontoItem>1000</MontoItem></Detalle><TED version="1.0"><DD><RE>11111111-1</RE><TD>33</TD><F>127</F><FE>2025-11-29</FE><RR>11111111-1</RR><RSR>CLIENTE PRUEBA</RSR><MNT>1190</MNT><IT1>Servicio X</IT1><CAF version="1.0"><DA><RE>11111111-1</RE><RS>Mi Pyme SpA</RS><TD>33</TD><RNG><D>127</D><H>127</H></RNG><FA>2025-11-29</FA><RSAPK><M>AA==</M><E>AA==</E></RSAPK><IDK>FAKE-IDK</IDK></DA><FRMA algoritmo="SHA1withRSA">AA==</FRMA></CAF><TSTED>2025-11-29T22:45:51</TSTED></DD><FRMT algoritmo="SHA1withRSA">cStFGMVhorMMA3QiKS35A/jtQHiuKXZ+PFFOyD47tcvs8QFR02MxfLt2Pbm0MA9YwS0gQxjy2utR1X1YZVVDPMYR3/IFl++m0Ia2SoXUvW4mX7OpSlI+GZdB6yGwkJ7SrJ6Aj+qTu21Rso8SWQIS6mi7DA7gH/ONp3GFkHttkrIiMrXC+ZbV5IC/xuTYNp1lG74gZgv0OKFIx5801FRuKmCHQuEMIXyQUyjdw8MuuTsvpWMJB9UaQw+vjhQYvRT+XRvSDjxbHq7hBK/pBqMiANxXAERGNI02OO2Cv4DuuBqmC5vM3nCLwbJqYYVqd4nK4waLURu1TIzYOVS3Dui5IQ==</FRMT></TED><TmstFirma>2025-11-29T22:45:51</TmstFirma></Documento><ds:Signature><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" /><ds:Reference URI=""><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" /><ds:DigestValue>AA==</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>AA==</ds:SignatureValue><ds:KeyInfo><ds:X509Data><ds:X509Certificate>AA==</ds:X509Certificate></ds:X509Data></ds:KeyInfo></ds:Signature></DTE></SetDTE><ds:Signature><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" /><ds:Reference URI=""><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" /><ds:DigestValue>AA==</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>AA==</ds:SignatureValue><ds:KeyInfo><ds:KeyValue><ds:RSAKeyValue><ds:Modulus>AA==</ds:Modulus><ds:Exponent>AA==</ds:Exponent></ds:RSAKeyValue></ds:KeyValue></ds:KeyInfo></ds:Signature></EnvioDTE>
33	1	1	33	128	11.111.111-1	Cliente Prueba	Av. Chile 123	Santiago	1000.00	190.00	1190.00	DUMMY-9E81BB01F5	ENVIADO	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<DTE xmlns="http://www.sii.cl/SiiDte" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" version="1.0"><Documento ID="F33T33"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>128</Folio><FchEmis>2025-11-29</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><Acteco>123456</Acteco><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>11111111-1</RUTRecep><RznSocRecep>Cliente Prueba</RznSocRecep><DirRecep>Av. Chile 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>1000</MntNeto><IVA>190</IVA><MntTotal>1190</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio X</NmbItem><QtyItem>1.00</QtyItem><PrcItem>1000.00</PrcItem><MontoItem>1000</MontoItem></Detalle><TED version="1.0"><DD><RE>11111111-1</RE><TD>33</TD><F>128</F><FE>2025-11-29</FE><RR>11111111-1</RR><RSR>CLIENTE PRUEBA</RSR><MNT>1190</MNT><IT1>Servicio X</IT1><CAF version="1.0"><DA><RE>11111111-1</RE><RS>Mi Pyme SpA</RS><TD>33</TD><RNG><D>128</D><H>128</H></RNG><FA>2025-11-29</FA><RSAPK><M>AA==</M><E>AA==</E></RSAPK><IDK>1</IDK></DA><FRMA algoritmo="SHA1withRSA">AA==</FRMA></CAF><TSTED>2025-11-29T23:23:38</TSTED></DD><FRMT algoritmo="SHA1withRSA">mE5UQ6G6yVy0A6iwtYsZkUJcQnXU4wE6Q638xN55dtPAUGTD0kJWJEXSoL48awidW6VaLI3fJBd44o176YBaU9RkLnQ/zDp+Gi//j+xidG/4+6Bl4Tl8CLoLolD0l1eDy2eQWjgOzQ0GXpFrREXHOcrJ5w7Z4bOz8qGRP+8SEFC+kcXHwTpEDAb0Mk53So7ykR6dxnWKE+o/9ONivCwiDak8JzPQXIE6yVHQzVTWq9gUf0dMqZfyh/3hWIGUZtabaT8emYGBF73Q5C1wCLEykZfSj7laT1NU2KIOR96RI0VJYAC/tTJJGz6IVl2EqauJAly3uQ1seK3hs4kgJsrefQ==</FRMT></TED><TmstFirma>2025-11-29T23:23:39</TmstFirma></Documento><ds:Signature><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" /><ds:Reference URI=""><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" /><ds:DigestValue>AA==</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>AA==</ds:SignatureValue><ds:KeyInfo><ds:KeyValue><ds:RSAKeyValue><ds:Modulus>AA==</ds:Modulus><ds:Exponent>AA==</ds:Exponent></ds:RSAKeyValue></ds:KeyValue></ds:KeyInfo></ds:Signature></DTE>	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<EnvioDTE xmlns="http://www.sii.cl/SiiDte" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" xsi:schemaLocation="http://www.sii.cl/SiiDte EnvioDTE_v10.xsd"><SetDTE ID="SetDoc_20251129232339"><Caratula version="1.0"><RutEmisor>11111111-1</RutEmisor><RutEnvia>11111111-1</RutEnvia><RutReceptor>60803000-K</RutReceptor><FchResol>2020-01-01</FchResol><NroResol>0</NroResol><TmstFirmaEnv>2025-11-29T23:23:39</TmstFirmaEnv><SubTotDTE><TpoDTE>33</TpoDTE><NroDTE>1</NroDTE></SubTotDTE></Caratula><DTE version="1.0"><Documento ID="F33T33"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>128</Folio><FchEmis>2025-11-29</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><Acteco>123456</Acteco><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>11111111-1</RUTRecep><RznSocRecep>Cliente Prueba</RznSocRecep><DirRecep>Av. Chile 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>1000</MntNeto><IVA>190</IVA><MntTotal>1190</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio X</NmbItem><QtyItem>1.00</QtyItem><PrcItem>1000.00</PrcItem><MontoItem>1000</MontoItem></Detalle><TED version="1.0"><DD><RE>11111111-1</RE><TD>33</TD><F>128</F><FE>2025-11-29</FE><RR>11111111-1</RR><RSR>CLIENTE PRUEBA</RSR><MNT>1190</MNT><IT1>Servicio X</IT1><CAF version="1.0"><DA><RE>11111111-1</RE><RS>Mi Pyme SpA</RS><TD>33</TD><RNG><D>128</D><H>128</H></RNG><FA>2025-11-29</FA><RSAPK><M>AA==</M><E>AA==</E></RSAPK><IDK>1</IDK></DA><FRMA algoritmo="SHA1withRSA">AA==</FRMA></CAF><TSTED>2025-11-29T23:23:38</TSTED></DD><FRMT algoritmo="SHA1withRSA">mE5UQ6G6yVy0A6iwtYsZkUJcQnXU4wE6Q638xN55dtPAUGTD0kJWJEXSoL48awidW6VaLI3fJBd44o176YBaU9RkLnQ/zDp+Gi//j+xidG/4+6Bl4Tl8CLoLolD0l1eDy2eQWjgOzQ0GXpFrREXHOcrJ5w7Z4bOz8qGRP+8SEFC+kcXHwTpEDAb0Mk53So7ykR6dxnWKE+o/9ONivCwiDak8JzPQXIE6yVHQzVTWq9gUf0dMqZfyh/3hWIGUZtabaT8emYGBF73Q5C1wCLEykZfSj7laT1NU2KIOR96RI0VJYAC/tTJJGz6IVl2EqauJAly3uQ1seK3hs4kgJsrefQ==</FRMT></TED><TmstFirma>2025-11-29T23:23:39</TmstFirma></Documento><ds:Signature><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" /><ds:Reference URI=""><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" /><ds:DigestValue>AA==</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>AA==</ds:SignatureValue><ds:KeyInfo><ds:KeyValue><ds:RSAKeyValue><ds:Modulus>AA==</ds:Modulus><ds:Exponent>AA==</ds:Exponent></ds:RSAKeyValue></ds:KeyValue></ds:KeyInfo></ds:Signature></DTE></SetDTE><ds:Signature><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" /><ds:Reference URI=""><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" /><ds:DigestValue>AA==</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>AA==</ds:SignatureValue><ds:KeyInfo><ds:KeyValue><ds:RSAKeyValue><ds:Modulus>AA==</ds:Modulus><ds:Exponent>AA==</ds:Exponent></ds:RSAKeyValue></ds:KeyValue></ds:KeyInfo></ds:Signature></EnvioDTE>
34	1	1	33	129	11.111.111-1	Cliente Prueba	Av. Chile 123	Santiago	1000.00	190.00	1190.00	DUMMY-B23EF6C801	ENVIADO	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<DTE xmlns="http://www.sii.cl/SiiDte" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" version="1.0"><Documento ID="F33T34"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>129</Folio><FchEmis>2025-11-29</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><Acteco>123456</Acteco><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>11111111-1</RUTRecep><RznSocRecep>Cliente Prueba</RznSocRecep><DirRecep>Av. Chile 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>1000</MntNeto><IVA>190</IVA><MntTotal>1190</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio X</NmbItem><QtyItem>1.00</QtyItem><PrcItem>1000.00</PrcItem><MontoItem>1000</MontoItem></Detalle><TED version="1.0"><DD><RE>11111111-1</RE><TD>33</TD><F>129</F><FE>2025-11-29</FE><RR>11111111-1</RR><RSR>CLIENTE PRUEBA</RSR><MNT>1190</MNT><IT1>Servicio X</IT1><CAF version="1.0"><DA><RE>11111111-1</RE><RS>Mi Pyme SpA</RS><TD>33</TD><RNG><D>129</D><H>129</H></RNG><FA>2025-11-29</FA><RSAPK><M>AA==</M><E>AA==</E></RSAPK><IDK>1</IDK></DA><FRMA algoritmo="SHA1withRSA">AA==</FRMA></CAF><TSTED>2025-11-29T23:33:15</TSTED></DD><FRMT algoritmo="SHA1withRSA">ZIu2wjNdAV+qCKI/C9Oh+mr6qtIWL8E9Oh5vbqR7iM2YdUhmoowoOL0tCidV22p8fA3l4vAJLxXBBCMYPIIceGKxlYN2XpDIh4F+nshVG2pZbsFR6FdzBTUJ9PN0o5/SntadX/vGRmEyVZPIwD3oIlUUjoztYyJHNGCJPct86uKcAHpZ0oy6gM5vE0VABZhdOdcY+FNV6ion2J8AHmXrp/rYPJfsn1rQ0Np2ADyyUIS2sgGkWsnPMG76t7rQqttqCKmZCgFAIdZRug8yW806yo9lhnLBZuJUj9iwJTl51jZ/GPDZU8filzPbog9UlG6dknfelxaZBK+oO1HeVYumbQ==</FRMT></TED><TmstFirma>2025-11-29T23:33:15</TmstFirma></Documento><ds:Signature><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" /><ds:Reference URI=""><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" /><ds:DigestValue>AA==</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>AA==</ds:SignatureValue><ds:KeyInfo><ds:X509Data><ds:X509Certificate>AA==</ds:X509Certificate></ds:X509Data></ds:KeyInfo></ds:Signature></DTE>	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<EnvioDTE xmlns="http://www.sii.cl/SiiDte" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" xsi:schemaLocation="http://www.sii.cl/SiiDte EnvioDTE_v10.xsd"><SetDTE ID="SetDoc_20251129233315"><Caratula version="1.0"><RutEmisor>11111111-1</RutEmisor><RutEnvia>11111111-1</RutEnvia><RutReceptor>60803000-K</RutReceptor><FchResol>2020-01-01</FchResol><NroResol>0</NroResol><TmstFirmaEnv>2025-11-29T23:33:15</TmstFirmaEnv><SubTotDTE><TpoDTE>33</TpoDTE><NroDTE>1</NroDTE></SubTotDTE></Caratula><DTE version="1.0"><Documento ID="F33T34"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>129</Folio><FchEmis>2025-11-29</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><Acteco>123456</Acteco><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>11111111-1</RUTRecep><RznSocRecep>Cliente Prueba</RznSocRecep><DirRecep>Av. Chile 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>1000</MntNeto><IVA>190</IVA><MntTotal>1190</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio X</NmbItem><QtyItem>1.00</QtyItem><PrcItem>1000.00</PrcItem><MontoItem>1000</MontoItem></Detalle><TED version="1.0"><DD><RE>11111111-1</RE><TD>33</TD><F>129</F><FE>2025-11-29</FE><RR>11111111-1</RR><RSR>CLIENTE PRUEBA</RSR><MNT>1190</MNT><IT1>Servicio X</IT1><CAF version="1.0"><DA><RE>11111111-1</RE><RS>Mi Pyme SpA</RS><TD>33</TD><RNG><D>129</D><H>129</H></RNG><FA>2025-11-29</FA><RSAPK><M>AA==</M><E>AA==</E></RSAPK><IDK>1</IDK></DA><FRMA algoritmo="SHA1withRSA">AA==</FRMA></CAF><TSTED>2025-11-29T23:33:15</TSTED></DD><FRMT algoritmo="SHA1withRSA">ZIu2wjNdAV+qCKI/C9Oh+mr6qtIWL8E9Oh5vbqR7iM2YdUhmoowoOL0tCidV22p8fA3l4vAJLxXBBCMYPIIceGKxlYN2XpDIh4F+nshVG2pZbsFR6FdzBTUJ9PN0o5/SntadX/vGRmEyVZPIwD3oIlUUjoztYyJHNGCJPct86uKcAHpZ0oy6gM5vE0VABZhdOdcY+FNV6ion2J8AHmXrp/rYPJfsn1rQ0Np2ADyyUIS2sgGkWsnPMG76t7rQqttqCKmZCgFAIdZRug8yW806yo9lhnLBZuJUj9iwJTl51jZ/GPDZU8filzPbog9UlG6dknfelxaZBK+oO1HeVYumbQ==</FRMT></TED><TmstFirma>2025-11-29T23:33:15</TmstFirma></Documento><ds:Signature><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" /><ds:Reference URI=""><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" /><ds:DigestValue>AA==</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>AA==</ds:SignatureValue><ds:KeyInfo><ds:X509Data><ds:X509Certificate>AA==</ds:X509Certificate></ds:X509Data></ds:KeyInfo></ds:Signature></DTE></SetDTE><ds:Signature><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" /><ds:Reference URI=""><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" /><ds:DigestValue>AA==</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>AA==</ds:SignatureValue><ds:KeyInfo><ds:KeyValue><ds:RSAKeyValue><ds:Modulus>AA==</ds:Modulus><ds:Exponent>AA==</ds:Exponent></ds:RSAKeyValue></ds:KeyValue></ds:KeyInfo></ds:Signature></EnvioDTE>
35	1	1	33	130	11.111.111-1	Cliente Prueba	Av. Chile 123	Santiago	1000.00	190.00	1190.00	DUMMY-2935B90DC4	ENVIADO	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<DTE xmlns="http://www.sii.cl/SiiDte" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" version="1.0"><Documento ID="F33T35"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>130</Folio><FchEmis>2025-11-30</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><Acteco>123456</Acteco><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>11111111-1</RUTRecep><RznSocRecep>Cliente Prueba</RznSocRecep><DirRecep>Av. Chile 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>1000</MntNeto><IVA>190</IVA><MntTotal>1190</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio X</NmbItem><QtyItem>1.00</QtyItem><PrcItem>1000.00</PrcItem><MontoItem>1000</MontoItem></Detalle><TED version="1.0"><DD><RE>11111111-1</RE><TD>33</TD><F>130</F><FE>2025-11-30</FE><RR>11111111-1</RR><RSR>CLIENTE PRUEBA</RSR><MNT>1190</MNT><IT1>Servicio X</IT1><CAF version="1.0"><DA><RE>11111111-1</RE><RS>Mi Pyme SpA</RS><TD>33</TD><RNG><D>130</D><H>130</H></RNG><FA>2025-11-30</FA><RSAPK><M>AA==</M><E>AA==</E></RSAPK><IDK>1</IDK></DA><FRMA algoritmo="SHA1withRSA">AA==</FRMA></CAF><TSTED>2025-11-30T01:32:10</TSTED></DD><FRMT algoritmo="SHA1withRSA">JvG9+W8un0R0d6Q9uFSqI8GBaIRwhc+cXDd9I9+nPhTnVVy1/9J7UQ7nbuPE/ZTcxIx4zawAem1PyGbm9XUxiQhYIoTib/O+yINV2U5dOcRNZvmX4Kw8/plGpy8uSZDc3Q2uWrBZ/yXrniRF9YI0Pvs6g0lZicnFSuF5Aikkknh8Jdq/kfO/NJ0tFbm22TsDqeS3HJKRMBca6s4DQVC8Vp7k2O6FFUzvBC/lrgVv08XLdxglTAmuAP9jNKMq5STMdwIesym8UEg8ua2hxkAfZaVP0eCf0Bl2Ba/jiDlEKIKAXj3cpxlvw0xBn15Dm5SpxCgvQrC4dmWQVUCNPpEcgA==</FRMT></TED><TmstFirma>2025-11-30T01:32:10</TmstFirma></Documento><ds:Signature><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" /><ds:Reference URI="#F33T35"><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" /><ds:DigestValue>AA==</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>AA==</ds:SignatureValue><ds:KeyInfo><ds:KeyValue><ds:RSAKeyValue><ds:Modulus>AA==</ds:Modulus><ds:Exponent>AA==</ds:Exponent></ds:RSAKeyValue></ds:KeyValue><ds:X509Data><ds:X509Certificate>AA==</ds:X509Certificate></ds:X509Data></ds:KeyInfo></ds:Signature></DTE>	\N	<?xml version='1.0' encoding='iso-8859-1'?>\n<EnvioDTE xmlns="http://www.sii.cl/SiiDte" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" xsi:schemaLocation="http://www.sii.cl/SiiDte EnvioDTE_v10.xsd"><SetDTE ID="SetDoc_20251130013210"><Caratula version="1.0"><RutEmisor>11111111-1</RutEmisor><RutEnvia>11111111-1</RutEnvia><RutReceptor>60803000-K</RutReceptor><FchResol>2020-01-01</FchResol><NroResol>0</NroResol><TmstFirmaEnv>2025-11-30T01:32:10</TmstFirmaEnv><SubTotDTE><TpoDTE>33</TpoDTE><NroDTE>1</NroDTE></SubTotDTE></Caratula><DTE version="1.0"><Documento ID="F33T35"><Encabezado><IdDoc><TipoDTE>33</TipoDTE><Folio>130</Folio><FchEmis>2025-11-30</FchEmis></IdDoc><Emisor><RUTEmisor>11111111-1</RUTEmisor><RznSoc>Mi Pyme SpA</RznSoc><GiroEmis>Servicios Informáticos</GiroEmis><Acteco>123456</Acteco><DirOrigen>Av. Siempre Viva 123</DirOrigen><CmnaOrigen>Santiago</CmnaOrigen></Emisor><Receptor><RUTRecep>11111111-1</RUTRecep><RznSocRecep>Cliente Prueba</RznSocRecep><DirRecep>Av. Chile 123</DirRecep><CmnaRecep>Santiago</CmnaRecep></Receptor><Totales><MntNeto>1000</MntNeto><IVA>190</IVA><MntTotal>1190</MntTotal></Totales></Encabezado><Detalle><NroLinDet>1</NroLinDet><NmbItem>Servicio X</NmbItem><QtyItem>1.00</QtyItem><PrcItem>1000.00</PrcItem><MontoItem>1000</MontoItem></Detalle><TED version="1.0"><DD><RE>11111111-1</RE><TD>33</TD><F>130</F><FE>2025-11-30</FE><RR>11111111-1</RR><RSR>CLIENTE PRUEBA</RSR><MNT>1190</MNT><IT1>Servicio X</IT1><CAF version="1.0"><DA><RE>11111111-1</RE><RS>Mi Pyme SpA</RS><TD>33</TD><RNG><D>130</D><H>130</H></RNG><FA>2025-11-30</FA><RSAPK><M>AA==</M><E>AA==</E></RSAPK><IDK>1</IDK></DA><FRMA algoritmo="SHA1withRSA">AA==</FRMA></CAF><TSTED>2025-11-30T01:32:10</TSTED></DD><FRMT algoritmo="SHA1withRSA">JvG9+W8un0R0d6Q9uFSqI8GBaIRwhc+cXDd9I9+nPhTnVVy1/9J7UQ7nbuPE/ZTcxIx4zawAem1PyGbm9XUxiQhYIoTib/O+yINV2U5dOcRNZvmX4Kw8/plGpy8uSZDc3Q2uWrBZ/yXrniRF9YI0Pvs6g0lZicnFSuF5Aikkknh8Jdq/kfO/NJ0tFbm22TsDqeS3HJKRMBca6s4DQVC8Vp7k2O6FFUzvBC/lrgVv08XLdxglTAmuAP9jNKMq5STMdwIesym8UEg8ua2hxkAfZaVP0eCf0Bl2Ba/jiDlEKIKAXj3cpxlvw0xBn15Dm5SpxCgvQrC4dmWQVUCNPpEcgA==</FRMT></TED><TmstFirma>2025-11-30T01:32:10</TmstFirma></Documento><ds:Signature><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" /><ds:Reference URI="#F33T35"><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" /><ds:DigestValue>AA==</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>AA==</ds:SignatureValue><ds:KeyInfo><ds:KeyValue><ds:RSAKeyValue><ds:Modulus>AA==</ds:Modulus><ds:Exponent>AA==</ds:Exponent></ds:RSAKeyValue></ds:KeyValue><ds:X509Data><ds:X509Certificate>AA==</ds:X509Certificate></ds:X509Data></ds:KeyInfo></ds:Signature></DTE></SetDTE><ds:Signature><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" /><ds:Reference URI="#SetDoc_20251130013210"><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" /><ds:DigestValue>AA==</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>AA==</ds:SignatureValue><ds:KeyInfo><ds:KeyValue><ds:RSAKeyValue><ds:Modulus>AA==</ds:Modulus><ds:Exponent>AA==</ds:Exponent></ds:RSAKeyValue></ds:KeyValue><ds:X509Data><ds:X509Certificate>AA==</ds:X509Certificate></ds:X509Data></ds:KeyInfo></ds:Signature></EnvioDTE>
\.


--
-- TOC entry 4991 (class 0 OID 49170)
-- Dependencies: 222
-- Data for Name: emitters; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.emitters (id, client_id, rut_emisor, razon_social, direccion, comuna, giro, cert_alias, sii_environment, sii_status) FROM stdin;
1	1	11111111-1	Mi Pyme SpA	Av. Siempre Viva 123	Santiago	Servicios Informáticos	\N	CERT	PENDIENTE
2	1	string	string	string	string	string	\N	CERT	PENDIENTE
\.


--
-- TOC entry 4997 (class 0 OID 49239)
-- Dependencies: 228
-- Data for Name: log_events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.log_events (id, document_id, client_id, level, origin, message, payload) FROM stdin;
1	2	1	INFO	SII	Iniciando construcción de XML DTE	\N
2	2	1	INFO	SII	XML DTE generado (dummy)	\N
3	2	1	INFO	SII	Documento enviado al SII (dummy)	{"track_id": "1BFFADEE7AA7"}
4	3	1	INFO	SII	Iniciando construcción de XML DTE	\N
5	3	1	INFO	SII	XML DTE generado	\N
6	3	1	INFO	SII	Documento enviado al SII (dummy)	{"track_id": "74966B9F8100"}
7	4	1	INFO	SII	Iniciando construcción de XML DTE	\N
8	4	1	INFO	SII	XML DTE generado	\N
9	4	1	INFO	SII	Documento enviado al SII (dummy)	{"track_id": "D7CAE7DDD35D"}
10	5	1	INFO	SII	Iniciando construcción de XML DTE	\N
11	5	1	INFO	SII	XML DTE generado	\N
12	5	1	INFO	SII	Documento enviado al SII (dummy)	{"track_id": "CA2702AF622A"}
13	6	1	INFO	SII	Iniciando construcción de XML DTE	\N
14	6	1	INFO	SII	XML DTE generado	\N
15	6	1	INFO	SII	Documento enviado al SII (dummy)	{"track_id": "E65A99902BF5"}
16	7	1	INFO	SII	Iniciando construcción de XML DTE	\N
17	7	1	INFO	SII	XML DTE generado	\N
18	7	1	INFO	SII	Documento enviado al SII (dummy)	{"track_id": "817C8F6498EA"}
19	8	1	INFO	SII	Iniciando construcción de XML DTE	\N
20	8	1	INFO	SII	XML DTE generado	\N
21	8	1	INFO	SII	Documento enviado al SII (dummy)	{"track_id": "E831CD4E0FD3"}
22	9	1	INFO	SII	Iniciando construcción de XML DTE	\N
23	9	1	INFO	SII	XML DTE generado	\N
24	9	1	INFO	SII	Documento enviado al SII (dummy)	{"track_id": "499C623F97AB"}
25	10	1	INFO	SII	Iniciando construcción de XML DTE	\N
26	10	1	ERROR	SII	Error al procesar envío a SII: CAF XML no tiene nodo <CAF>	\N
27	11	1	INFO	SII	Iniciando construcción de XML DTE	\N
28	11	1	ERROR	SII	Error al procesar envío a SII: CAF XML no tiene nodo <CAF>	\N
29	11	1	INFO	SII	Iniciando construcción de XML DTE	\N
30	11	1	ERROR	SII	Error al procesar envío a SII: CAF XML no tiene nodo <CAF>	\N
31	12	1	INFO	SII	Iniciando construcción de XML DTE	\N
32	12	1	ERROR	SII	Error al procesar envío a SII: CAF XML no tiene nodo <CAF>	\N
33	13	1	INFO	SII	Iniciando construcción de XML DTE	\N
34	13	1	ERROR	SII	Error al procesar envío a SII: CAF XML no tiene nodo <CAF>	\N
35	13	1	INFO	SII	Iniciando construcción de XML DTE	\N
36	13	1	ERROR	SII	Error al procesar envío a SII: CAF XML no tiene nodo <CAF>	\N
37	13	1	INFO	SII	Iniciando construcción de XML DTE	\N
38	13	1	ERROR	SII	Error al procesar envío a SII: CAF XML no tiene nodo <CAF>	\N
39	14	1	INFO	SII	Iniciando construcción de XML DTE	\N
40	14	1	ERROR	SII	Error al procesar envío a SII: CAF XML no tiene nodo <CAF>	\N
41	15	1	INFO	SII	Iniciando construcción de XML DTE	\N
42	15	1	ERROR	SII	Error al procesar envío a SII: CAF XML no tiene nodo <CAF>	\N
43	16	1	INFO	SII	Iniciando construcción de XML DTE	\N
44	16	1	WARNING	SII	Error al parsear CAF, se generará TED sin CAF incrustado: CAF XML no tiene nodo <CAF>	\N
45	16	1	INFO	SII	XML DTE generado	\N
46	16	1	INFO	SII	Documento enviado al SII (dummy)	{"track_id": "B6DAF8EB3B71"}
47	17	1	INFO	SII	Iniciando construcción de XML DTE	\N
48	17	1	WARNING	SII	Error al parsear CAF, se generará TED sin CAF incrustado: CAF XML no tiene nodo <CAF>	\N
49	17	1	INFO	SII	XML DTE generado	\N
50	17	1	INFO	SII	Documento enviado al SII (dummy)	{"track_id": "13AD436770E1"}
51	18	1	INFO	SII	Iniciando construcción de XML DTE	\N
52	18	1	WARNING	SII	Error al parsear CAF, se generará TED sin CAF incrustado: CAF XML no tiene nodo <CAF>	\N
53	18	1	INFO	SII	XML DTE generado	\N
54	18	1	INFO	SII	Documento enviado al SII (dummy)	{"track_id": "82222C18F859"}
55	19	1	INFO	SII	Iniciando construcción de XML DTE	\N
56	19	1	WARNING	SII	Error al parsear CAF, se generará TED sin CAF incrustado: CAF XML no tiene nodo <CAF>	\N
57	19	1	ERROR	SII	Error al procesar envío a SII: unknown method 'c14n'	\N
58	20	1	INFO	SII	Iniciando construcción de XML DTE	\N
59	20	1	WARNING	SII	Error al parsear CAF, se generará TED sin CAF incrustado: CAF XML no tiene nodo <CAF>	\N
60	20	1	ERROR	SII	Error al procesar envío a SII: unknown method 'c14n'	\N
61	20	1	INFO	SII	Iniciando construcción de XML DTE	\N
62	20	1	WARNING	SII	Error al parsear CAF, se generará TED sin CAF incrustado: CAF XML no tiene nodo <CAF>	\N
63	20	1	ERROR	SII	Error al procesar envío a SII: unknown method 'c14n'	\N
64	21	1	INFO	SII	Iniciando construcción de XML DTE	\N
65	21	1	WARNING	SII	Error al parsear CAF, se generará TED sin CAF incrustado: CAF XML no tiene nodo <CAF>	\N
66	21	1	INFO	SII	XML DTE generado	\N
67	21	1	INFO	SII	Documento enviado al SII (dummy)	{"track_id": "20E6F2C77634"}
68	22	1	INFO	SII	Iniciando construcción de XML DTE	\N
69	22	1	WARNING	SII	Error al parsear CAF, se generará TED sin CAF incrustado: CAF XML no tiene nodo <CAF>	\N
70	22	1	INFO	SII	XML DTE generado	\N
71	22	1	INFO	SII	EnvioDTE generado (Carátula + SetDTE + Signature dummy)	\N
72	22	1	INFO	SII	EnvioDTE enviado al SII (dummy)	{"track_id": "BC7C38E63B26"}
73	23	1	INFO	SII	Iniciando construcción de XML DTE	\N
74	23	1	WARNING	SII	Error al parsear CAF, se generará TED sin CAF incrustado: CAF XML no tiene nodo <CAF>	\N
75	23	1	INFO	SII	XML DTE generado	\N
76	23	1	INFO	SII	EnvioDTE generado (dummy)	\N
77	23	1	INFO	SII	EnvioDTE enviado al SII (dummy)	{"track_id": "DUMMY-AD5B39D11B"}
78	24	1	INFO	SII	Iniciando construcción de XML DTE	\N
79	24	1	WARNING	SII	Error al parsear CAF, se generará TED sin CAF incrustado: CAF XML no tiene nodo <CAF>	\N
80	24	1	INFO	SII	XML DTE generado	\N
81	24	1	ERROR	SII	Errores de validación XML DTE	{"errors": ["<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_ELT_1: Element 'DTE': No matching global declaration available for the validation root."]}
82	24	1	ERROR	SII	Error al procesar envío a SII: XML DTE inválido según schema SII	\N
83	25	1	INFO	SII	Iniciando construcción de XML DTE	\N
84	25	1	WARNING	SII	Error al parsear CAF, se generará TED sin CAF incrustado: CAF XML no tiene nodo <CAF>	\N
85	25	1	INFO	SII	XML DTE generado	\N
86	25	1	ERROR	SII	Errores de validación XML DTE	{"errors": ["<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}DirOrigen': This element is not expected. Expected is one of ( {http://www.sii.cl/SiiDte}Telefono, {http://www.sii.cl/SiiDte}CorreoEmisor, {http://www.sii.cl/SiiDte}Acteco ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_MAXLENGTH_VALID: Element '{http://www.sii.cl/SiiDte}RUTRecep': [facet 'maxLength'] The value has a length of '12'; this exceeds the allowed maximum length of '10'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_PATTERN_VALID: Element '{http://www.sii.cl/SiiDte}RUTRecep': [facet 'pattern'] The value '11.111.111-1' is not accepted by the pattern '[0-9]+-([0-9]|K)'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_DATATYPE_VALID_1_2_1: Element '{http://www.sii.cl/SiiDte}FE': '20251126' is not a valid value of the atomic type '{http://www.sii.cl/SiiDte}FechaType'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_MAXLENGTH_VALID: Element '{http://www.sii.cl/SiiDte}RR': [facet 'maxLength'] The value has a length of '12'; this exceeds the allowed maximum length of '10'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_PATTERN_VALID: Element '{http://www.sii.cl/SiiDte}RR': [facet 'pattern'] The value '11.111.111-1' is not accepted by the pattern '[0-9]+-([0-9]|K)'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}TSTED': This element is not expected. Expected is ( {http://www.sii.cl/SiiDte}CAF ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}FRMA': This element is not expected. Expected is ( {http://www.sii.cl/SiiDte}FRMT ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}DTE': Missing child element(s). Expected is ( {http://www.w3.org/2000/09/xmldsig#}Signature )."]}
87	25	1	WARNING	SII	XML DTE con errores de validación XSD, se continúa flujo igualmente (modo dummy)	\N
88	25	1	INFO	SII	EnvioDTE generado (dummy)	\N
89	25	1	ERROR	SII	Errores de validación XML EnvioDTE	{"errors": ["Exception: Attribute xmlns redefined, line 2, column 136 (<string>, line 2)"]}
90	25	1	WARNING	SII	EnvioDTE con errores de validación XSD, se continúa flujo igualmente (modo dummy)	\N
91	25	1	INFO	SII	EnvioDTE enviado al SII (dummy)	{"track_id": "DUMMY-DD3C2E0979"}
92	26	1	INFO	SII	Iniciando construcción de XML DTE	\N
93	26	1	WARNING	SII	Error al parsear CAF, se generará TED sin CAF incrustado: CAF XML no tiene nodo <CAF>	\N
94	26	1	INFO	SII	XML DTE generado	\N
95	26	1	ERROR	SII	Errores de validación XML DTE	{"errors": ["<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}DirOrigen': This element is not expected. Expected is one of ( {http://www.sii.cl/SiiDte}Telefono, {http://www.sii.cl/SiiDte}CorreoEmisor, {http://www.sii.cl/SiiDte}Acteco ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_MAXLENGTH_VALID: Element '{http://www.sii.cl/SiiDte}RUTRecep': [facet 'maxLength'] The value has a length of '12'; this exceeds the allowed maximum length of '10'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_PATTERN_VALID: Element '{http://www.sii.cl/SiiDte}RUTRecep': [facet 'pattern'] The value '11.111.111-1' is not accepted by the pattern '[0-9]+-([0-9]|K)'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_DATATYPE_VALID_1_2_1: Element '{http://www.sii.cl/SiiDte}FE': '20251126' is not a valid value of the atomic type '{http://www.sii.cl/SiiDte}FechaType'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_MAXLENGTH_VALID: Element '{http://www.sii.cl/SiiDte}RR': [facet 'maxLength'] The value has a length of '12'; this exceeds the allowed maximum length of '10'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_PATTERN_VALID: Element '{http://www.sii.cl/SiiDte}RR': [facet 'pattern'] The value '11.111.111-1' is not accepted by the pattern '[0-9]+-([0-9]|K)'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}TSTED': This element is not expected. Expected is ( {http://www.sii.cl/SiiDte}CAF ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}FRMA': This element is not expected. Expected is ( {http://www.sii.cl/SiiDte}FRMT ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}DTE': Missing child element(s). Expected is ( {http://www.w3.org/2000/09/xmldsig#}Signature )."]}
96	26	1	WARNING	SII	XML DTE con errores de validación XSD, se continúa flujo igualmente (modo dummy)	\N
97	26	1	INFO	SII	EnvioDTE generado (dummy)	\N
98	26	1	ERROR	SII	Errores de validación XML EnvioDTE	{"errors": ["<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}DirOrigen': This element is not expected. Expected is one of ( {http://www.sii.cl/SiiDte}Telefono, {http://www.sii.cl/SiiDte}CorreoEmisor, {http://www.sii.cl/SiiDte}Acteco ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_MAXLENGTH_VALID: Element '{http://www.sii.cl/SiiDte}RUTRecep': [facet 'maxLength'] The value has a length of '12'; this exceeds the allowed maximum length of '10'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_PATTERN_VALID: Element '{http://www.sii.cl/SiiDte}RUTRecep': [facet 'pattern'] The value '11.111.111-1' is not accepted by the pattern '[0-9]+-([0-9]|K)'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_DATATYPE_VALID_1_2_1: Element '{http://www.sii.cl/SiiDte}FE': '20251126' is not a valid value of the atomic type '{http://www.sii.cl/SiiDte}FechaType'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_MAXLENGTH_VALID: Element '{http://www.sii.cl/SiiDte}RR': [facet 'maxLength'] The value has a length of '12'; this exceeds the allowed maximum length of '10'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_PATTERN_VALID: Element '{http://www.sii.cl/SiiDte}RR': [facet 'pattern'] The value '11.111.111-1' is not accepted by the pattern '[0-9]+-([0-9]|K)'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}TSTED': This element is not expected. Expected is ( {http://www.sii.cl/SiiDte}CAF ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}FRMA': This element is not expected. Expected is ( {http://www.sii.cl/SiiDte}FRMT ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}DTE': Missing child element(s). Expected is ( {http://www.w3.org/2000/09/xmldsig#}Signature ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_DATATYPE_VALID_1_2_1: Element '{http://www.w3.org/2000/09/xmldsig#}DigestValue': 'DIGEST_PLACEHOLDER' is not a valid value of the atomic type 'xs:base64Binary'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.w3.org/2000/09/xmldsig#}KeyName': This element is not expected. Expected is ( {http://www.w3.org/2000/09/xmldsig#}KeyValue )."]}
99	26	1	WARNING	SII	EnvioDTE con errores de validación XSD, se continúa flujo igualmente (modo dummy)	\N
100	26	1	INFO	SII	EnvioDTE enviado al SII (dummy)	{"track_id": "DUMMY-C940FD1D5C"}
101	27	1	INFO	SII	Iniciando construcción de XML DTE	\N
102	27	1	WARNING	SII	Error al parsear CAF, se generará TED sin CAF incrustado: CAF XML no tiene nodo <CAF>	\N
103	27	1	INFO	SII	XML DTE generado	\N
125	29	1	ERROR	SII	Errores de validación XML EnvioDTE	{"errors": ["<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_DATATYPE_VALID_1_2_1: Element '{http://www.sii.cl/SiiDte}Acteco': '000000' is not a valid value of the local atomic type.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}TSTED': This element is not expected. Expected is ( {http://www.sii.cl/SiiDte}CAF ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.w3.org/2000/09/xmldsig#}KeyValue': Missing child element(s). Expected is one of ( {http://www.w3.org/2000/09/xmldsig#}RSAKeyValue, {http://www.w3.org/2000/09/xmldsig#}DSAKeyValue ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.w3.org/2000/09/xmldsig#}KeyInfo': Missing child element(s). Expected is ( {http://www.w3.org/2000/09/xmldsig#}X509Data ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_DATATYPE_VALID_1_2_1: Element '{http://www.w3.org/2000/09/xmldsig#}DigestValue': 'DIGEST_PLACEHOLDER' is not a valid value of the atomic type 'xs:base64Binary'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.w3.org/2000/09/xmldsig#}KeyName': This element is not expected. Expected is ( {http://www.w3.org/2000/09/xmldsig#}KeyValue )."]}
104	27	1	ERROR	SII	Errores de validación XML DTE	{"errors": ["<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}DirOrigen': This element is not expected. Expected is one of ( {http://www.sii.cl/SiiDte}Telefono, {http://www.sii.cl/SiiDte}CorreoEmisor, {http://www.sii.cl/SiiDte}Acteco ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_MAXLENGTH_VALID: Element '{http://www.sii.cl/SiiDte}RUTRecep': [facet 'maxLength'] The value has a length of '12'; this exceeds the allowed maximum length of '10'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_PATTERN_VALID: Element '{http://www.sii.cl/SiiDte}RUTRecep': [facet 'pattern'] The value '11.111.111-1' is not accepted by the pattern '[0-9]+-([0-9]|K)'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_DATATYPE_VALID_1_2_1: Element '{http://www.sii.cl/SiiDte}FE': '20251126' is not a valid value of the atomic type '{http://www.sii.cl/SiiDte}FechaType'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_MAXLENGTH_VALID: Element '{http://www.sii.cl/SiiDte}RR': [facet 'maxLength'] The value has a length of '12'; this exceeds the allowed maximum length of '10'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_PATTERN_VALID: Element '{http://www.sii.cl/SiiDte}RR': [facet 'pattern'] The value '11.111.111-1' is not accepted by the pattern '[0-9]+-([0-9]|K)'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}TSTED': This element is not expected. Expected is ( {http://www.sii.cl/SiiDte}CAF ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}FRMA': This element is not expected. Expected is ( {http://www.sii.cl/SiiDte}FRMT ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}DTE': Missing child element(s). Expected is ( {http://www.w3.org/2000/09/xmldsig#}Signature )."]}
105	27	1	WARNING	SII	XML DTE con errores de validación XSD, se continúa flujo igualmente (modo dummy)	\N
106	27	1	INFO	SII	EnvioDTE generado (dummy)	\N
107	27	1	ERROR	SII	Errores de validación XML EnvioDTE	{"errors": ["<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}DirOrigen': This element is not expected. Expected is one of ( {http://www.sii.cl/SiiDte}Telefono, {http://www.sii.cl/SiiDte}CorreoEmisor, {http://www.sii.cl/SiiDte}Acteco ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_MAXLENGTH_VALID: Element '{http://www.sii.cl/SiiDte}RUTRecep': [facet 'maxLength'] The value has a length of '12'; this exceeds the allowed maximum length of '10'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_PATTERN_VALID: Element '{http://www.sii.cl/SiiDte}RUTRecep': [facet 'pattern'] The value '11.111.111-1' is not accepted by the pattern '[0-9]+-([0-9]|K)'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_DATATYPE_VALID_1_2_1: Element '{http://www.sii.cl/SiiDte}FE': '20251126' is not a valid value of the atomic type '{http://www.sii.cl/SiiDte}FechaType'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_MAXLENGTH_VALID: Element '{http://www.sii.cl/SiiDte}RR': [facet 'maxLength'] The value has a length of '12'; this exceeds the allowed maximum length of '10'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_PATTERN_VALID: Element '{http://www.sii.cl/SiiDte}RR': [facet 'pattern'] The value '11.111.111-1' is not accepted by the pattern '[0-9]+-([0-9]|K)'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}TSTED': This element is not expected. Expected is ( {http://www.sii.cl/SiiDte}CAF ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}FRMA': This element is not expected. Expected is ( {http://www.sii.cl/SiiDte}FRMT ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}DTE': Missing child element(s). Expected is ( {http://www.w3.org/2000/09/xmldsig#}Signature ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_DATATYPE_VALID_1_2_1: Element '{http://www.w3.org/2000/09/xmldsig#}DigestValue': 'DIGEST_PLACEHOLDER' is not a valid value of the atomic type 'xs:base64Binary'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.w3.org/2000/09/xmldsig#}KeyName': This element is not expected. Expected is ( {http://www.w3.org/2000/09/xmldsig#}KeyValue )."]}
108	27	1	WARNING	SII	EnvioDTE con errores de validación XSD, se continúa flujo igualmente (modo dummy)	\N
109	27	1	INFO	SII	EnvioDTE enviado al SII (dummy)	{"track_id": "DUMMY-9A1D4CE455"}
110	28	1	INFO	SII	Iniciando construcción de XML DTE	\N
111	28	1	WARNING	SII	Error al parsear CAF, se generará TED sin CAF incrustado: CAF XML no tiene nodo <CAF>	\N
112	28	1	INFO	SII	XML DTE generado	\N
113	28	1	ERROR	SII	Errores de validación XML DTE	{"errors": ["<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_DATATYPE_VALID_1_2_1: Element '{http://www.sii.cl/SiiDte}Acteco': '000000' is not a valid value of the local atomic type.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}TSTED': This element is not expected. Expected is ( {http://www.sii.cl/SiiDte}CAF ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.w3.org/2000/09/xmldsig#}KeyValue': Missing child element(s). Expected is one of ( {http://www.w3.org/2000/09/xmldsig#}RSAKeyValue, {http://www.w3.org/2000/09/xmldsig#}DSAKeyValue ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.w3.org/2000/09/xmldsig#}KeyInfo': Missing child element(s). Expected is ( {http://www.w3.org/2000/09/xmldsig#}X509Data )."]}
114	28	1	WARNING	SII	XML DTE con errores de validación XSD, se continúa flujo igualmente (modo dummy)	\N
115	28	1	INFO	SII	EnvioDTE generado (dummy)	\N
116	28	1	ERROR	SII	Errores de validación XML EnvioDTE	{"errors": ["<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_DATATYPE_VALID_1_2_1: Element '{http://www.sii.cl/SiiDte}Acteco': '000000' is not a valid value of the local atomic type.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}TSTED': This element is not expected. Expected is ( {http://www.sii.cl/SiiDte}CAF ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.w3.org/2000/09/xmldsig#}KeyValue': Missing child element(s). Expected is one of ( {http://www.w3.org/2000/09/xmldsig#}RSAKeyValue, {http://www.w3.org/2000/09/xmldsig#}DSAKeyValue ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.w3.org/2000/09/xmldsig#}KeyInfo': Missing child element(s). Expected is ( {http://www.w3.org/2000/09/xmldsig#}X509Data ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_DATATYPE_VALID_1_2_1: Element '{http://www.w3.org/2000/09/xmldsig#}DigestValue': 'DIGEST_PLACEHOLDER' is not a valid value of the atomic type 'xs:base64Binary'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.w3.org/2000/09/xmldsig#}KeyName': This element is not expected. Expected is ( {http://www.w3.org/2000/09/xmldsig#}KeyValue )."]}
117	28	1	WARNING	SII	EnvioDTE con errores de validación XSD, se continúa flujo igualmente (modo dummy)	\N
118	28	1	INFO	SII	EnvioDTE enviado al SII (dummy)	{"track_id": "DUMMY-3FE0BE7A13"}
119	29	1	INFO	SII	Iniciando construcción de XML DTE	\N
120	29	1	WARNING	SII	Error al parsear CAF, se generará TED sin CAF incrustado: CAF XML no tiene nodo <CAF>	\N
121	29	1	INFO	SII	XML DTE generado	\N
122	29	1	ERROR	SII	Errores de validación XML DTE	{"errors": ["<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_DATATYPE_VALID_1_2_1: Element '{http://www.sii.cl/SiiDte}Acteco': '000000' is not a valid value of the local atomic type.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}TSTED': This element is not expected. Expected is ( {http://www.sii.cl/SiiDte}CAF ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.w3.org/2000/09/xmldsig#}KeyValue': Missing child element(s). Expected is one of ( {http://www.w3.org/2000/09/xmldsig#}RSAKeyValue, {http://www.w3.org/2000/09/xmldsig#}DSAKeyValue ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.w3.org/2000/09/xmldsig#}KeyInfo': Missing child element(s). Expected is ( {http://www.w3.org/2000/09/xmldsig#}X509Data )."]}
123	29	1	WARNING	SII	XML DTE con errores de validación XSD, se continúa flujo igualmente (modo dummy)	\N
124	29	1	INFO	SII	EnvioDTE generado (dummy)	\N
126	29	1	WARNING	SII	EnvioDTE con errores de validación XSD, se continúa flujo igualmente (modo dummy)	\N
127	29	1	INFO	SII	EnvioDTE enviado al SII (dummy)	{"track_id": "DUMMY-B65D800892"}
128	30	1	INFO	SII	Iniciando construcción de XML DTE	\N
129	30	1	WARNING	SII	Error al parsear CAF, se usará CAF fake en TED: CAF XML no tiene nodo <CAF>	\N
130	30	1	INFO	SII	XML DTE generado	\N
131	30	1	ERROR	SII	Errores de validación XML DTE	{"errors": ["<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}DirOrigen': This element is not expected. Expected is one of ( {http://www.sii.cl/SiiDte}CorreoEmisor, {http://www.sii.cl/SiiDte}Acteco ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}DA': Missing child element(s). Expected is one of ( {http://www.sii.cl/SiiDte}RSAPK, {http://www.sii.cl/SiiDte}DSAPK ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_COMPLEX_TYPE_4: Element '{http://www.sii.cl/SiiDte}FRMA': The attribute 'algoritmo' is required but missing.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.w3.org/2000/09/xmldsig#}X509Data': This element is not expected. Expected is ( {http://www.w3.org/2000/09/xmldsig#}KeyValue )."]}
132	30	1	WARNING	SII	XML DTE con errores de validación XSD, se continúa flujo igualmente (modo dummy)	\N
133	30	1	INFO	SII	EnvioDTE generado (dummy)	\N
134	30	1	ERROR	SII	Errores de validación XML EnvioDTE	{"errors": ["<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}DirOrigen': This element is not expected. Expected is one of ( {http://www.sii.cl/SiiDte}CorreoEmisor, {http://www.sii.cl/SiiDte}Acteco ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}DA': Missing child element(s). Expected is one of ( {http://www.sii.cl/SiiDte}RSAPK, {http://www.sii.cl/SiiDte}DSAPK ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_COMPLEX_TYPE_4: Element '{http://www.sii.cl/SiiDte}FRMA': The attribute 'algoritmo' is required but missing.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.w3.org/2000/09/xmldsig#}X509Data': This element is not expected. Expected is ( {http://www.w3.org/2000/09/xmldsig#}KeyValue ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.w3.org/2000/09/xmldsig#}X509Data': This element is not expected. Expected is ( {http://www.w3.org/2000/09/xmldsig#}KeyValue )."]}
135	30	1	WARNING	SII	EnvioDTE con errores de validación XSD, se continúa flujo igualmente (modo dummy)	\N
136	30	1	INFO	SII	EnvioDTE enviado al SII (dummy)	{"track_id": "DUMMY-F110241399"}
137	31	1	INFO	SII	Iniciando construcción de XML DTE	\N
138	31	1	WARNING	SII	Error al parsear CAF, se usará CAF fake en TED: CAF XML no tiene nodo <CAF>	\N
139	31	1	INFO	SII	XML DTE generado	\N
140	31	1	ERROR	SII	Errores de validación XML DTE	{"errors": ["<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_COMPLEX_TYPE_2_3: Element '{http://www.sii.cl/SiiDte}RSAPK': Character content other than whitespace is not allowed because the content type is 'element-only'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}RSAPK': Missing child element(s). Expected is ( {http://www.sii.cl/SiiDte}M ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}DA': Missing child element(s). Expected is ( {http://www.sii.cl/SiiDte}IDK ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_ENUMERATION_VALID: Element '{http://www.w3.org/2000/09/xmldsig#}SignatureMethod', attribute 'Algorithm': [facet 'enumeration'] The value 'http://www.w3.org/2000/09/xmldsig#rsa-sh1' is not an element of the set {'http://www.w3.org/2000/09/xmldsig#rsa-sha1', 'http://www.w3.org/2000/09/xmldsig#dsa-sha1'}.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.w3.org/2000/09/xmldsig#}KeyInfo': Missing child element(s). Expected is ( {http://www.w3.org/2000/09/xmldsig#}X509Data )."]}
141	31	1	WARNING	SII	XML DTE con errores de validación XSD, se continúa flujo igualmente (modo dummy)	\N
142	31	1	INFO	SII	EnvioDTE generado (dummy)	\N
143	31	1	ERROR	SII	Errores de validación XML EnvioDTE	{"errors": ["<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_COMPLEX_TYPE_2_3: Element '{http://www.sii.cl/SiiDte}RSAPK': Character content other than whitespace is not allowed because the content type is 'element-only'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}RSAPK': Missing child element(s). Expected is ( {http://www.sii.cl/SiiDte}M ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.sii.cl/SiiDte}DA': Missing child element(s). Expected is ( {http://www.sii.cl/SiiDte}IDK ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_ENUMERATION_VALID: Element '{http://www.w3.org/2000/09/xmldsig#}SignatureMethod', attribute 'Algorithm': [facet 'enumeration'] The value 'http://www.w3.org/2000/09/xmldsig#rsa-sh1' is not an element of the set {'http://www.w3.org/2000/09/xmldsig#rsa-sha1', 'http://www.w3.org/2000/09/xmldsig#dsa-sha1'}.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.w3.org/2000/09/xmldsig#}KeyInfo': Missing child element(s). Expected is ( {http://www.w3.org/2000/09/xmldsig#}X509Data ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.w3.org/2000/09/xmldsig#}X509Data': This element is not expected. Expected is ( {http://www.w3.org/2000/09/xmldsig#}KeyValue )."]}
144	31	1	WARNING	SII	EnvioDTE con errores de validación XSD, se continúa flujo igualmente (modo dummy)	\N
145	31	1	INFO	SII	EnvioDTE enviado al SII (dummy)	{"track_id": "DUMMY-0335C4D5B1"}
146	32	1	INFO	SII	Iniciando construcción de XML DTE	\N
147	32	1	WARNING	SII	Error al parsear CAF, se usará CAF fake en TED: CAF XML no tiene nodo <CAF>	\N
148	32	1	INFO	SII	XML DTE generado	\N
149	32	1	ERROR	SII	Errores de validación XML DTE	{"errors": ["<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_DATATYPE_VALID_1_2_1: Element '{http://www.sii.cl/SiiDte}IDK': 'FAKE-IDK' is not a valid value of the atomic type 'xs:long'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.w3.org/2000/09/xmldsig#}X509Data': This element is not expected. Expected is ( {http://www.w3.org/2000/09/xmldsig#}KeyValue )."]}
150	32	1	WARNING	SII	XML DTE con errores de validación XSD, se continúa flujo igualmente (modo dummy)	\N
151	32	1	INFO	SII	EnvioDTE generado (dummy)	\N
152	32	1	ERROR	SII	Errores de validación XML EnvioDTE	{"errors": ["<string>:2:0:ERROR:SCHEMASV:SCHEMAV_CVC_DATATYPE_VALID_1_2_1: Element '{http://www.sii.cl/SiiDte}IDK': 'FAKE-IDK' is not a valid value of the atomic type 'xs:long'.", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.w3.org/2000/09/xmldsig#}X509Data': This element is not expected. Expected is ( {http://www.w3.org/2000/09/xmldsig#}KeyValue ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.w3.org/2000/09/xmldsig#}KeyInfo': Missing child element(s). Expected is ( {http://www.w3.org/2000/09/xmldsig#}X509Data )."]}
153	32	1	WARNING	SII	EnvioDTE con errores de validación XSD, se continúa flujo igualmente (modo dummy)	\N
154	32	1	INFO	SII	EnvioDTE enviado al SII (dummy)	{"track_id": "DUMMY-41825DA347"}
155	33	1	INFO	SII	Iniciando construcción de XML DTE	\N
156	33	1	WARNING	SII	Error al parsear CAF, se usará CAF fake en TED: CAF XML no tiene nodo <CAF>	\N
157	33	1	INFO	SII	XML DTE generado	\N
158	33	1	ERROR	SII	Errores de validación XML DTE	{"errors": ["<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.w3.org/2000/09/xmldsig#}KeyInfo': Missing child element(s). Expected is ( {http://www.w3.org/2000/09/xmldsig#}X509Data )."]}
159	33	1	WARNING	SII	XML DTE con errores de validación XSD, se continúa flujo igualmente (modo dummy)	\N
160	33	1	INFO	SII	EnvioDTE generado (dummy)	\N
161	33	1	ERROR	SII	Errores de validación XML EnvioDTE	{"errors": ["<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.w3.org/2000/09/xmldsig#}KeyInfo': Missing child element(s). Expected is ( {http://www.w3.org/2000/09/xmldsig#}X509Data ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.w3.org/2000/09/xmldsig#}KeyInfo': Missing child element(s). Expected is ( {http://www.w3.org/2000/09/xmldsig#}X509Data )."]}
162	33	1	WARNING	SII	EnvioDTE con errores de validación XSD, se continúa flujo igualmente (modo dummy)	\N
163	33	1	INFO	SII	EnvioDTE enviado al SII (dummy)	{"track_id": "DUMMY-9E81BB01F5"}
164	34	1	INFO	SII	Iniciando construcción de XML DTE	\N
165	34	1	WARNING	SII	Error al parsear CAF, se usará CAF fake en TED: CAF XML no tiene nodo <CAF>	\N
166	34	1	INFO	SII	XML DTE generado	\N
167	34	1	ERROR	SII	Errores de validación XML DTE	{"errors": ["<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.w3.org/2000/09/xmldsig#}X509Data': This element is not expected. Expected is ( {http://www.w3.org/2000/09/xmldsig#}KeyValue )."]}
168	34	1	WARNING	SII	XML DTE con errores de validación XSD, se continúa flujo igualmente (modo dummy)	\N
169	34	1	INFO	SII	EnvioDTE generado (dummy)	\N
170	34	1	ERROR	SII	Errores de validación XML EnvioDTE	{"errors": ["<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.w3.org/2000/09/xmldsig#}X509Data': This element is not expected. Expected is ( {http://www.w3.org/2000/09/xmldsig#}KeyValue ).", "<string>:2:0:ERROR:SCHEMASV:SCHEMAV_ELEMENT_CONTENT: Element '{http://www.w3.org/2000/09/xmldsig#}KeyInfo': Missing child element(s). Expected is ( {http://www.w3.org/2000/09/xmldsig#}X509Data )."]}
171	34	1	WARNING	SII	EnvioDTE con errores de validación XSD, se continúa flujo igualmente (modo dummy)	\N
172	34	1	INFO	SII	EnvioDTE enviado al SII (dummy)	{"track_id": "DUMMY-B23EF6C801"}
173	35	1	INFO	SII	Iniciando construcción de XML DTE	\N
174	35	1	WARNING	SII	Error al parsear CAF, se usará CAF fake en TED: CAF XML no tiene nodo <CAF>	\N
175	35	1	INFO	SII	XML DTE generado	\N
176	35	1	INFO	SII	EnvioDTE generado (dummy)	\N
177	35	1	INFO	SII	EnvioDTE enviado al SII (dummy)	{"track_id": "DUMMY-2935B90DC4"}
\.


--
-- TOC entry 5003 (class 0 OID 81944)
-- Dependencies: 234
-- Data for Name: user_activity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_activity (id, user_id, client_id, action, method, path, status_code, success, error_message, ip_address, user_agent, extra, created_at) FROM stdin;
\.


--
-- TOC entry 5001 (class 0 OID 81927)
-- Dependencies: 232
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, username, hashed_password, is_active, created_at) FROM stdin;
2	admin@example.com	admin	$pbkdf2-sha256$29000$gFDqfQ9hLGXMOedcSwkBQA$hmRc/oHSvwow.3gAmpeK/A6ewPZWFO93FJ5SEsvgC/g	t	2025-11-30 18:31:47.562278-03
\.


--
-- TOC entry 5017 (class 0 OID 0)
-- Dependencies: 229
-- Name: caf_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.caf_id_seq', 1, true);


--
-- TOC entry 5018 (class 0 OID 0)
-- Dependencies: 219
-- Name: clients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clients_id_seq', 1, true);


--
-- TOC entry 5019 (class 0 OID 0)
-- Dependencies: 225
-- Name: document_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.document_items_id_seq', 58, true);


--
-- TOC entry 5020 (class 0 OID 0)
-- Dependencies: 223
-- Name: documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.documents_id_seq', 35, true);


--
-- TOC entry 5021 (class 0 OID 0)
-- Dependencies: 221
-- Name: emitters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.emitters_id_seq', 2, true);


--
-- TOC entry 5022 (class 0 OID 0)
-- Dependencies: 227
-- Name: log_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.log_events_id_seq', 177, true);


--
-- TOC entry 5023 (class 0 OID 0)
-- Dependencies: 233
-- Name: user_activity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_activity_id_seq', 1, false);


--
-- TOC entry 5024 (class 0 OID 0)
-- Dependencies: 231
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 2, true);


--
-- TOC entry 4819 (class 2606 OID 57361)
-- Name: caf caf_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caf
    ADD CONSTRAINT caf_pkey PRIMARY KEY (id);


--
-- TOC entry 4801 (class 2606 OID 49166)
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- TOC entry 4813 (class 2606 OID 49231)
-- Name: document_items document_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.document_items
    ADD CONSTRAINT document_items_pkey PRIMARY KEY (id);


--
-- TOC entry 4809 (class 2606 OID 49206)
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- TOC entry 4805 (class 2606 OID 49181)
-- Name: emitters emitters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emitters
    ADD CONSTRAINT emitters_pkey PRIMARY KEY (id);


--
-- TOC entry 4817 (class 2606 OID 49248)
-- Name: log_events log_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_events
    ADD CONSTRAINT log_events_pkey PRIMARY KEY (id);


--
-- TOC entry 4822 (class 2606 OID 57363)
-- Name: caf uix_caf_emitter_tipo_rango; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caf
    ADD CONSTRAINT uix_caf_emitter_tipo_rango UNIQUE (emitter_id, tipo_dte, folio_inicial, folio_final);


--
-- TOC entry 4833 (class 2606 OID 81958)
-- Name: user_activity user_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_activity
    ADD CONSTRAINT user_activity_pkey PRIMARY KEY (id);


--
-- TOC entry 4827 (class 2606 OID 81939)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4820 (class 1259 OID 57369)
-- Name: ix_caf_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_caf_id ON public.caf USING btree (id);


--
-- TOC entry 4802 (class 1259 OID 49167)
-- Name: ix_clients_api_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_clients_api_key ON public.clients USING btree (api_key);


--
-- TOC entry 4803 (class 1259 OID 49168)
-- Name: ix_clients_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_clients_id ON public.clients USING btree (id);


--
-- TOC entry 4814 (class 1259 OID 49237)
-- Name: ix_document_items_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_document_items_id ON public.document_items USING btree (id);


--
-- TOC entry 4810 (class 1259 OID 49218)
-- Name: ix_documents_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_documents_id ON public.documents USING btree (id);


--
-- TOC entry 4811 (class 1259 OID 49217)
-- Name: ix_documents_sii_track_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_documents_sii_track_id ON public.documents USING btree (sii_track_id);


--
-- TOC entry 4806 (class 1259 OID 49188)
-- Name: ix_emitters_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_emitters_id ON public.emitters USING btree (id);


--
-- TOC entry 4807 (class 1259 OID 49187)
-- Name: ix_emitters_rut_emisor; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_emitters_rut_emisor ON public.emitters USING btree (rut_emisor);


--
-- TOC entry 4815 (class 1259 OID 49259)
-- Name: ix_log_events_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_log_events_id ON public.log_events USING btree (id);


--
-- TOC entry 4828 (class 1259 OID 81959)
-- Name: ix_user_activity_client_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_user_activity_client_id ON public.user_activity USING btree (client_id);


--
-- TOC entry 4829 (class 1259 OID 81961)
-- Name: ix_user_activity_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_user_activity_created_at ON public.user_activity USING btree (created_at);


--
-- TOC entry 4830 (class 1259 OID 81962)
-- Name: ix_user_activity_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_user_activity_id ON public.user_activity USING btree (id);


--
-- TOC entry 4831 (class 1259 OID 81960)
-- Name: ix_user_activity_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_user_activity_user_id ON public.user_activity USING btree (user_id);


--
-- TOC entry 4823 (class 1259 OID 81941)
-- Name: ix_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_users_email ON public.users USING btree (email);


--
-- TOC entry 4824 (class 1259 OID 81940)
-- Name: ix_users_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_users_id ON public.users USING btree (id);


--
-- TOC entry 4825 (class 1259 OID 81942)
-- Name: ix_users_username; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_users_username ON public.users USING btree (username);


--
-- TOC entry 4840 (class 2606 OID 57364)
-- Name: caf caf_emitter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caf
    ADD CONSTRAINT caf_emitter_id_fkey FOREIGN KEY (emitter_id) REFERENCES public.emitters(id);


--
-- TOC entry 4837 (class 2606 OID 49232)
-- Name: document_items document_items_document_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.document_items
    ADD CONSTRAINT document_items_document_id_fkey FOREIGN KEY (document_id) REFERENCES public.documents(id);


--
-- TOC entry 4835 (class 2606 OID 49207)
-- Name: documents documents_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- TOC entry 4836 (class 2606 OID 49212)
-- Name: documents documents_emitter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_emitter_id_fkey FOREIGN KEY (emitter_id) REFERENCES public.emitters(id);


--
-- TOC entry 4834 (class 2606 OID 49182)
-- Name: emitters emitters_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emitters
    ADD CONSTRAINT emitters_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- TOC entry 4838 (class 2606 OID 49254)
-- Name: log_events log_events_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_events
    ADD CONSTRAINT log_events_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- TOC entry 4839 (class 2606 OID 49249)
-- Name: log_events log_events_document_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_events
    ADD CONSTRAINT log_events_document_id_fkey FOREIGN KEY (document_id) REFERENCES public.documents(id);


-- Completed on 2025-11-30 23:11:58

--
-- PostgreSQL database dump complete
--

\unrestrict K4hWu6dLGDNzRDCx02tVlbJe73glE0EYbLMyKNmWtoqGgdDQL71SeS3t1J15PBM

