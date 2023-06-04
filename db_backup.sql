--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2 (Debian 15.2-1.pgdg110+1)
-- Dumped by pg_dump version 15.2 (Debian 15.2-1.pgdg110+1)

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
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


--
-- Name: bcrypt_hash(text); Type: FUNCTION; Schema: public; Owner: meetnow-user
--

CREATE FUNCTION public.bcrypt_hash(p_password text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_salt TEXT;
BEGIN
    v_salt := gen_salt('bf', 8);
    RETURN crypt(p_password, v_salt);
END;
$$;


ALTER FUNCTION public.bcrypt_hash(p_password text) OWNER TO "meetnow-user";

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: authorities; Type: TABLE; Schema: public; Owner: meetnow-user
--

CREATE TABLE public.authorities (
    username character varying(50) NOT NULL,
    authority character varying(50) NOT NULL
);


ALTER TABLE public.authorities OWNER TO "meetnow-user";

--
-- Name: event; Type: TABLE; Schema: public; Owner: meetnow-user
--

CREATE TABLE public.event (
    id integer NOT NULL,
    title character varying(255),
    description text,
    type character varying(255),
    image character varying(255),
    coordinates public.geometry(Point,4326),
    start_date timestamp without time zone,
    end_date timestamp without time zone
);


ALTER TABLE public.event OWNER TO "meetnow-user";

--
-- Name: event_id_seq; Type: SEQUENCE; Schema: public; Owner: meetnow-user
--

CREATE SEQUENCE public.event_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.event_id_seq OWNER TO "meetnow-user";

--
-- Name: event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: meetnow-user
--

ALTER SEQUENCE public.event_id_seq OWNED BY public.event.id;


--
-- Name: event_post; Type: TABLE; Schema: public; Owner: meetnow-user
--

CREATE TABLE public.event_post (
    id integer NOT NULL,
    user_id bigint,
    event_id bigint,
    title character varying,
    image character varying,
    created timestamp without time zone
);


ALTER TABLE public.event_post OWNER TO "meetnow-user";

--
-- Name: event_post_id_seq; Type: SEQUENCE; Schema: public; Owner: meetnow-user
--

CREATE SEQUENCE public.event_post_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.event_post_id_seq OWNER TO "meetnow-user";

--
-- Name: event_post_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: meetnow-user
--

ALTER SEQUENCE public.event_post_id_seq OWNED BY public.event_post.id;


--
-- Name: flyway_schema_history; Type: TABLE; Schema: public; Owner: meetnow-user
--

CREATE TABLE public.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE public.flyway_schema_history OWNER TO "meetnow-user";

--
-- Name: host; Type: TABLE; Schema: public; Owner: meetnow-user
--

CREATE TABLE public.host (
    id integer NOT NULL,
    user_id bigint,
    event_id bigint
);


ALTER TABLE public.host OWNER TO "meetnow-user";

--
-- Name: host_id_seq; Type: SEQUENCE; Schema: public; Owner: meetnow-user
--

CREATE SEQUENCE public.host_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.host_id_seq OWNER TO "meetnow-user";

--
-- Name: host_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: meetnow-user
--

ALTER SEQUENCE public.host_id_seq OWNED BY public.host.id;


--
-- Name: participant; Type: TABLE; Schema: public; Owner: meetnow-user
--

CREATE TABLE public.participant (
    id integer NOT NULL,
    user_id bigint,
    event_id bigint
);


ALTER TABLE public.participant OWNER TO "meetnow-user";

--
-- Name: participant_id_seq; Type: SEQUENCE; Schema: public; Owner: meetnow-user
--

CREATE SEQUENCE public.participant_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.participant_id_seq OWNER TO "meetnow-user";

--
-- Name: participant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: meetnow-user
--

ALTER SEQUENCE public.participant_id_seq OWNED BY public.participant.id;


--
-- Name: user_personal_data; Type: TABLE; Schema: public; Owner: meetnow-user
--

CREATE TABLE public.user_personal_data (
    id integer NOT NULL,
    user_id bigint,
    first_name character varying(50),
    last_name character varying(50),
    image character varying(256),
    phone_nr character varying(16),
    date_of_birth date
);


ALTER TABLE public.user_personal_data OWNER TO "meetnow-user";

--
-- Name: user_personal_data_id_seq; Type: SEQUENCE; Schema: public; Owner: meetnow-user
--

CREATE SEQUENCE public.user_personal_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_personal_data_id_seq OWNER TO "meetnow-user";

--
-- Name: user_personal_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: meetnow-user
--

ALTER SEQUENCE public.user_personal_data_id_seq OWNED BY public.user_personal_data.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: meetnow-user
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    password character varying(100) NOT NULL,
    enabled boolean NOT NULL
);


ALTER TABLE public.users OWNER TO "meetnow-user";

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: meetnow-user
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO "meetnow-user";

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: meetnow-user
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: event id; Type: DEFAULT; Schema: public; Owner: meetnow-user
--

ALTER TABLE ONLY public.event ALTER COLUMN id SET DEFAULT nextval('public.event_id_seq'::regclass);


--
-- Name: event_post id; Type: DEFAULT; Schema: public; Owner: meetnow-user
--

ALTER TABLE ONLY public.event_post ALTER COLUMN id SET DEFAULT nextval('public.event_post_id_seq'::regclass);


--
-- Name: host id; Type: DEFAULT; Schema: public; Owner: meetnow-user
--

ALTER TABLE ONLY public.host ALTER COLUMN id SET DEFAULT nextval('public.host_id_seq'::regclass);


--
-- Name: participant id; Type: DEFAULT; Schema: public; Owner: meetnow-user
--

ALTER TABLE ONLY public.participant ALTER COLUMN id SET DEFAULT nextval('public.participant_id_seq'::regclass);


--
-- Name: user_personal_data id; Type: DEFAULT; Schema: public; Owner: meetnow-user
--

ALTER TABLE ONLY public.user_personal_data ALTER COLUMN id SET DEFAULT nextval('public.user_personal_data_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: meetnow-user
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: authorities; Type: TABLE DATA; Schema: public; Owner: meetnow-user
--

COPY public.authorities (username, authority) FROM stdin;
user	USER
\.


--
-- Data for Name: event; Type: TABLE DATA; Schema: public; Owner: meetnow-user
--

COPY public.event (id, title, description, type, image, coordinates, start_date, end_date) FROM stdin;
39	event user9 title	event desc suser9tring	Event	string	0101000020E61000005C8FC2F5285C3540E17A14AE47613540	2023-05-24 18:09:21.399	2023-11-24 18:09:21.399
27	Chess Tournament, More Players Needed	Hi! We are actively looking for the 5th person for our chess tournament. We guarantee a great batch of fun and ultimate chess experience.	Sport	https://example.com/event_image0	0101000020E6100000C6DCB5847CF033409B559FABAD084940	2023-05-31 12:25:48.716182	2023-05-22 05:43:01.138582
28	Saturday Night Party at Club X	Get ready to dance the night away at Club X this Saturday! Featuring DJ Y spinning the best tunes and drink specials all night long.	Party	https://example.com/event_image1	0101000020E61000000B462575021A344017B7D100DE0A4940	2023-05-13 02:41:56.885782	2023-05-20 02:34:50.559382
29	Local 5k Charity Run	Join us for a fun 5k run in support of a local charity. All fitness levels are welcome. Do not forget to bring your friends and family!	Sport	https://example.com/event_image2	0101000020E6100000E7FBA9F1D2DD33407B14AE47E1024940	2023-05-21 17:12:27.327382	2023-05-11 21:31:22.796182
30	Photography Workshop: Master Your Camera	Learn how to master your camera and take stunning photos in this hands-on photography workshop. Perfect for beginners and hobbyists alike.	Event	https://example.com/event_image3	0101000020E61000004F401361C3333440D95F764F1E0E4940	2023-05-16 09:25:49.839382	2023-05-31 09:31:57.615382
31	Outdoor Yoga Class for Beginners	Relax and unwind with an outdoor yoga class suitable for beginners. Bring your own mat and enjoy an hour of gentle stretching and meditation.	Sport	https://example.com/event_image4	0101000020E61000005DDC460378FB33403C4ED1915C064940	2023-06-03 07:40:25.013782	2023-05-28 10:46:57.500182
43	new event added TITLE	new event added DESC	Event	string.jpg	0101000020E610000014AE47E17AB44440F6285C8FC2B54440	2023-06-04 19:05:34.595	2023-11-04 19:05:34.595
\.


--
-- Data for Name: event_post; Type: TABLE DATA; Schema: public; Owner: meetnow-user
--

COPY public.event_post (id, user_id, event_id, title, image, created) FROM stdin;
1	35	31	See you next time 1	http://example.com/image.jpg	2023-05-06 19:40:45.74672
2	19	29	Live fast, die young, party harder than ever 2	http://example.com/image.jpg	2023-05-06 19:40:45.74672
3	39	27	Live fast, die young, party harder than ever 3	http://example.com/image.jpg	2023-05-06 19:40:45.74672
4	39	31	had fun 4	http://example.com/image.jpg	2023-05-06 19:40:45.74672
5	14	27	Had a blast, but now Im dead inside 5	http://example.com/image.jpg	2023-05-06 19:40:45.74672
6	27	28	Never going back to that place again. Save yourselves! 6	http://example.com/image.jpg	2023-05-06 19:40:45.74672
7	37	28	I thought it was supposed to be lit, but it was a total snoozefest 7	http://example.com/image.jpg	2023-05-06 19:40:45.74672
8	37	31	If youre not sweating and out of breath, youre not doing it right 8	http://example.com/image.jpg	2023-05-06 19:40:45.74672
9	35	31	Live fast, die young, party harder than ever 9	http://example.com/image.jpg	2023-05-06 19:40:45.74672
10	11	29	Never going back to that place again. Save yourselves! 10	http://example.com/image.jpg	2023-05-06 19:40:45.74672
11	26	27	I thought it was supposed to be lit, but it was a total snoozefest 11	http://example.com/image.jpg	2023-05-06 19:40:45.74672
12	19	29	had fun 12	http://example.com/image.jpg	2023-05-06 19:40:45.74672
13	14	29	I dont care what anyone says, its the best thing since sliced bread 13	http://example.com/image.jpg	2023-05-06 19:40:45.74672
14	12	31	Live fast, die young, party harder than ever 14	http://example.com/image.jpg	2023-05-06 19:40:45.74672
15	40	30	I cant even remember what happened, but I had fun 15	http://example.com/image.jpg	2023-05-06 19:40:45.74672
16	17	30	Why bother coming if youre not gonna dance like its your last night on earth? 16	http://example.com/image.jpg	2023-05-06 19:40:45.74672
17	15	28	I thought it was supposed to be lit, but it was a total snoozefest 17	http://example.com/image.jpg	2023-05-06 19:40:45.74672
18	11	28	Another night of regret and questionable decisions 18	http://example.com/image.jpg	2023-05-06 19:40:45.74672
19	44	27	I cant even remember what happened, but I had fun 19	http://example.com/image.jpg	2023-05-06 19:40:45.74672
20	43	28	had fun 20	http://example.com/image.jpg	2023-05-06 19:40:45.74672
21	40	30	I dont care what anyone says, its the best thing since sliced bread 21	http://example.com/image.jpg	2023-05-06 19:40:45.74672
22	22	28	meh 22	http://example.com/image.jpg	2023-05-06 19:40:45.74672
23	26	30	had fun 23	http://example.com/image.jpg	2023-05-06 19:40:45.74672
24	17	29	meh 24	http://example.com/image.jpg	2023-05-06 19:40:45.74672
25	10	29	I dont care what anyone says, its the best thing since sliced bread 25	http://example.com/image.jpg	2023-05-06 19:40:45.74672
26	19	27	See you next time 26	http://example.com/image.jpg	2023-05-06 19:40:45.74672
27	22	29	If youre not sweating and out of breath, youre not doing it right 27	http://example.com/image.jpg	2023-05-06 19:40:45.74672
28	39	27	Live fast, die young, party harder than ever 28	http://example.com/image.jpg	2023-05-06 19:40:45.74672
29	47	27	had fun 29	http://example.com/image.jpg	2023-05-06 19:40:45.74672
30	24	28	Never going back to that place again. Save yourselves! 30	http://example.com/image.jpg	2023-05-06 19:40:45.74672
31	43	29	Live fast, die young, party harder than ever 31	http://example.com/image.jpg	2023-05-06 19:40:45.74672
32	39	27	Why bother coming if youre not gonna dance like its your last night on earth? 32	http://example.com/image.jpg	2023-05-06 19:40:45.74672
33	27	28	Had a blast, but now Im dead inside 33	http://example.com/image.jpg	2023-05-06 19:40:45.74672
34	46	28	Live fast, die young, party harder than ever 34	http://example.com/image.jpg	2023-05-06 19:40:45.74672
35	47	27	I thought it was supposed to be lit, but it was a total snoozefest 35	http://example.com/image.jpg	2023-05-06 19:40:45.74672
36	42	28	I dont care what anyone says, its the best thing since sliced bread 36	http://example.com/image.jpg	2023-05-06 19:40:45.74672
37	44	28	If youre not sweating and out of breath, youre not doing it right 37	http://example.com/image.jpg	2023-05-06 19:40:45.74672
38	22	30	I thought it was supposed to be lit, but it was a total snoozefest 38	http://example.com/image.jpg	2023-05-06 19:40:45.74672
39	50	31	Had a blast, but now Im dead inside 39	http://example.com/image.jpg	2023-05-06 19:40:45.74672
40	24	28	Had a blast, but now Im dead inside 40	http://example.com/image.jpg	2023-05-06 19:40:45.74672
41	22	31	Feeling good today! 41	http://example.com/image.jpg	2023-05-06 19:40:45.74672
42	16	31	If youre not sweating and out of breath, youre not doing it right 42	http://example.com/image.jpg	2023-05-06 19:40:45.74672
43	40	27	Another night of regret and questionable decisions 43	http://example.com/image.jpg	2023-05-06 19:40:45.74672
44	49	28	I thought it was supposed to be lit, but it was a total snoozefest 44	http://example.com/image.jpg	2023-05-06 19:40:45.74672
45	25	29	I didnt think it was possible to have that much fun without breaking the law 45	http://example.com/image.jpg	2023-05-06 19:40:45.74672
46	37	30	If youre not sweating and out of breath, youre not doing it right 46	http://example.com/image.jpg	2023-05-06 19:40:45.74672
47	25	31	I cant even remember what happened, but I had fun 47	http://example.com/image.jpg	2023-05-06 19:40:45.74672
48	25	28	Never going back to that place again. Save yourselves! 48	http://example.com/image.jpg	2023-05-06 19:40:45.74672
49	27	28	Never going back to that place again. Save yourselves! 49	http://example.com/image.jpg	2023-05-06 19:40:45.74672
50	19	31	I didnt think it was possible to have that much fun without breaking the law 50	http://example.com/image.jpg	2023-05-06 19:40:45.74672
\.


--
-- Data for Name: flyway_schema_history; Type: TABLE DATA; Schema: public; Owner: meetnow-user
--

COPY public.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	initTables PS	SQL	V1__initTables_PS.sql	2134813502	meetnow-user	2023-03-26 21:37:27.511468	21	t
2	2	fixAuthoritiesTable	SQL	V2__fixAuthoritiesTable.sql	1585385360	meetnow-user	2023-03-26 21:37:27.59348	8	t
3	3	create personal data table PS	SQL	V3__create_personal_data_table_PS.sql	-1990742568	meetnow-user	2023-03-26 21:37:27.64654	58	t
4	4	create event related tables	SQL	V4__create_event_related_tables.sql	-348767589	meetnow-user	2023-03-26 21:37:27.739954	67	t
5	5	fixInitTableIssues	SQL	V5__fixInitTableIssues.sql	-2005974055	meetnow-user	2023-03-26 21:37:27.853243	71	t
6	6	EventPostTable	SQL	V6__EventPostTable.sql	136105845	meetnow-user	2023-03-26 21:37:27.960997	68	t
7	7	alterEventTable	SQL	V7__alterEventTable.sql	-1646050196	meetnow-user	2023-05-06 15:28:58.858946	77	t
8	8	addPostgisToEventTable	SQL	V8__addPostgisToEventTable.sql	601218361	meetnow-user	2023-05-13 13:42:26.633046	155	t
\.


--
-- Data for Name: host; Type: TABLE DATA; Schema: public; Owner: meetnow-user
--

COPY public.host (id, user_id, event_id) FROM stdin;
27	4	27
28	5	28
29	6	29
30	7	30
31	8	31
37	9	39
39	62	43
\.


--
-- Data for Name: participant; Type: TABLE DATA; Schema: public; Owner: meetnow-user
--

COPY public.participant (id, user_id, event_id) FROM stdin;
1	9	27
2	10	27
3	11	27
4	12	27
5	13	27
6	14	27
7	15	27
8	16	27
9	17	27
10	18	27
11	19	27
12	20	27
13	21	27
14	22	27
15	23	27
16	24	27
17	25	27
18	26	27
19	27	28
20	28	28
21	29	28
22	30	28
23	31	28
24	32	28
25	33	28
26	34	28
27	35	28
28	36	28
29	37	28
30	38	28
31	39	28
32	40	28
33	41	28
34	42	28
35	43	28
36	44	28
37	45	28
38	46	28
39	47	28
40	48	28
41	49	28
42	50	28
43	51	28
44	52	28
45	53	28
46	9	29
47	10	29
48	11	29
49	12	29
50	13	29
51	14	29
52	15	29
53	16	29
54	17	29
55	18	29
56	19	29
57	20	29
58	21	29
59	22	29
60	23	29
61	24	29
62	25	29
63	26	29
64	9	30
65	10	30
66	11	30
67	12	30
68	13	30
69	14	30
70	15	30
71	16	30
72	17	30
73	18	30
74	19	30
75	20	30
76	21	30
77	22	30
78	23	30
79	24	30
80	25	30
81	26	30
82	9	31
83	10	31
84	11	31
85	12	31
86	13	31
87	14	31
88	15	31
89	16	31
90	17	31
91	18	31
92	19	31
93	20	31
94	21	31
95	22	31
96	23	31
97	24	31
98	25	31
99	26	31
100	8	39
101	62	39
\.


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: meetnow-user
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: user_personal_data; Type: TABLE DATA; Schema: public; Owner: meetnow-user
--

COPY public.user_personal_data (id, user_id, first_name, last_name, image, phone_nr, date_of_birth) FROM stdin;
302	4	William	Rodriguez	https://example.com/image4	123-456-7894	2011-10-15
303	5	William	Smith	https://example.com/image5	123-456-7895	2019-09-25
304	6	William	Brown	https://example.com/image6	123-456-7896	1994-06-12
305	7	Emily	Jones	https://example.com/image7	123-456-7897	2015-07-10
306	8	James	Davis	https://example.com/image8	123-456-7898	2001-01-12
307	9	Emily	Miller	https://example.com/image9	123-456-7899	2013-09-02
308	10	William	Johnson	https://example.com/image10	123-456-78910	2017-08-30
309	11	Olivia	Williams	https://example.com/image11	123-456-78911	2004-01-05
310	12	James	Garcia	https://example.com/image12	123-456-78912	2010-03-27
311	13	John	Davis	https://example.com/image13	123-456-78913	2011-12-08
312	14	James	Rodriguez	https://example.com/image14	123-456-78914	2016-11-21
313	15	William	Williams	https://example.com/image15	123-456-78915	2009-02-24
314	16	Jane	Williams	https://example.com/image16	123-456-78916	2009-06-04
315	17	Olivia	Smith	https://example.com/image17	123-456-78917	2019-03-08
316	18	Olivia	Jones	https://example.com/image18	123-456-78918	1995-11-13
317	19	Emily	Williams	https://example.com/image19	123-456-78919	2021-09-29
318	20	Emily	Rodriguez	https://example.com/image20	123-456-78920	2004-10-22
319	21	Olivia	Williams	https://example.com/image21	123-456-78921	2015-05-25
320	22	James	Williams	https://example.com/image22	123-456-78922	1994-04-21
321	23	Michael	Johnson	https://example.com/image23	123-456-78923	2018-04-16
322	24	Sophia	Garcia	https://example.com/image24	123-456-78924	2008-11-19
323	25	Emily	Miller	https://example.com/image25	123-456-78925	2020-09-28
324	26	Emily	Davis	https://example.com/image26	123-456-78926	2014-12-18
325	27	Jane	Jones	https://example.com/image27	123-456-78927	2019-05-22
326	28	William	Jones	https://example.com/image28	123-456-78928	1999-01-02
327	29	David	Miller	https://example.com/image29	123-456-78929	2006-07-02
328	30	Jane	Rodriguez	https://example.com/image30	123-456-78930	2014-09-11
329	31	David	Miller	https://example.com/image31	123-456-78931	1999-06-06
330	32	William	Brown	https://example.com/image32	123-456-78932	1998-05-22
331	33	David	Miller	https://example.com/image33	123-456-78933	2003-10-02
332	34	John	Smith	https://example.com/image34	123-456-78934	2008-06-19
333	35	Olivia	Rodriguez	https://example.com/image35	123-456-78935	1997-09-10
334	36	Emily	Garcia	https://example.com/image36	123-456-78936	2021-10-19
335	37	David	Miller	https://example.com/image37	123-456-78937	2019-10-24
336	38	William	Williams	https://example.com/image38	123-456-78938	2020-03-03
337	39	William	Brown	https://example.com/image39	123-456-78939	2005-09-26
338	40	Michael	Garcia	https://example.com/image40	123-456-78940	2003-05-10
339	41	Isabella	Williams	https://example.com/image41	123-456-78941	2012-06-01
340	42	William	Miller	https://example.com/image42	123-456-78942	2002-06-27
341	43	Michael	Miller	https://example.com/image43	123-456-78943	1995-05-05
342	44	Sophia	Brown	https://example.com/image44	123-456-78944	2021-02-19
343	45	John	Davis	https://example.com/image45	123-456-78945	1993-09-28
344	46	Jane	Martinez	https://example.com/image46	123-456-78946	2005-06-02
345	47	Jane	Williams	https://example.com/image47	123-456-78947	1999-04-02
346	48	John	Brown	https://example.com/image48	123-456-78948	2008-12-14
347	49	Sophia	Williams	https://example.com/image49	123-456-78949	2005-02-28
348	50	Olivia	Johnson	https://example.com/image50	123-456-78950	2011-03-25
349	51	David	Davis	https://example.com/image51	123-456-78951	1994-04-27
350	52	Jane	Brown	https://example.com/image52	123-456-78952	2021-10-05
351	53	Emily	Jones	https://example.com/image53	123-456-78953	1995-04-11
352	54	string	string	string	\N	2023-05-12
353	55	string	string	string	\N	2023-05-12
354	58	string	string	string	\N	2023-05-12
355	59	string	string	string	\N	2023-05-12
356	60	string	string	string	\N	2023-05-12
357	61	string	string	string	\N	2023-05-14
358	62	string	string	string	\N	2023-06-04
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: meetnow-user
--

COPY public.users (id, username, email, password, enabled) FROM stdin;
1	user	user@user.com	$2a$10$1iZ.nxTTUmR4qimSgMCOh.inN7Ng0um9ddhhmnqRRLUOtOtglYsES	t
3	admin	admin@gmail.com	{bcrypt}$2a$10$rI4hC.vk0iBVjCMvkCHTcuwcvPKwfzf7fWwTXAT0fSpvCZhaTFMgC	t
54	ase4esadre3	stringdsa34	{bcrypt}$2a$10$27KDxX.z/MBf43a52FOnIeGAehMqWC8dotzlbDf8So/2pwOzEBMae	t
55	ase4esadrea23	stringdsaa234	{bcrypt}$2a$10$NfKkviUfGIwvGxyO0etHQOnjw79Vsb1Tj1m/gAomOKLE.FAIWwF2u	t
60	asd3s34	aess31124	{bcrypt}$2a$10$mtP9qKAcotl76W4NVic/LuZpcbQnpAoa.Y76P15yTiLEvSrPm6Htq	t
61	striesng	stringes	{bcrypt}$2a$10$jofYmQowkskkbZ5Q1Ixc1uuAYXJHG8pwubthrtPwP7ZE5NE.lSsSS	t
62	user101	string	{bcrypt}$2a$10$1fcbud7YxZpfQU1lLZTALupRwD4Txnej8fdbYqC8U.i8rVc0SzXO2	t
58	ase4esadrea23a1	a2ee	{bcrypt}$2a$10$KTCAv1SUk9hzmQDTB/GUvuX6sjthpbW2Rw5135mIv03aGZ0x9YU3y	t
4	user4	user4@example.com	{bcrypt}$2a$08$vZoJ10r0kDd3rQUt8wurr.QaLZ5xRTt7y.WJJogMtzb9QjA1417TC	t
5	user5	user5@example.com	{bcrypt}$2a$08$iwGRJFOuwkfao1CV2sqN7.fsjyk9rSc0WPxFgFAdwcHVhaS7UHXYm	t
6	user6	user6@example.com	{bcrypt}$2a$08$mZzBUrpoPea7V887jEVYTOPc3CsrkRR8zWoxnAQ16JR7JW3ATuMwq	t
7	user7	user7@example.com	{bcrypt}$2a$08$e4yAsY2a1boRu9JSyts86uCb6L9LnKHtUoLMo.uamA02kA0omL1Ee	t
8	user8	user8@example.com	{bcrypt}$2a$08$q6XqyDzy2ZZyJnVTnFEUROMdoWLswsRmy2Asu9ih6viDRKbI7YiYi	t
9	user9	user9@example.com	{bcrypt}$2a$08$O/z3E7ASfMeG7/cLyfdmWuw4CLQIHF1YMGxIuU3NEpDN2F7xjiuaS	t
10	user10	user10@example.com	{bcrypt}$2a$08$5aQvHtJ/WzBk7mSTr8bIJOT6GgP9DLXOLIx96viCWxHZN7vzO0MnG	t
11	user11	user11@example.com	{bcrypt}$2a$08$LeK.Sl.gxTPX9lcOYV5UP.RFi/hJZwewgvxYH7oWe7vJSnkwXSMDO	t
12	user12	user12@example.com	{bcrypt}$2a$08$bk3XiStMoZmm.mhR3KrRhu0tcFv7Fk6OL2Ts6JmEz6w62mKnepaea	t
13	user13	user13@example.com	{bcrypt}$2a$08$1UiQNV/b5bYmLzGvG8AodOA2LZI8DKU77KVZEhejuRwUtrkl/ZKxK	t
14	user14	user14@example.com	{bcrypt}$2a$08$256XAXrhQefATbjDd2cMgekdKghxDzyUOY.ICh8DwrW4Sm05EntrG	t
15	user15	user15@example.com	{bcrypt}$2a$08$KGoCTz0obupAzJKtdmeDPeut8hNf9eCjCi6bbLdCXWmfiqR8FQ7Fm	t
16	user16	user16@example.com	{bcrypt}$2a$08$bBPUXyYBI2D4Vq4D..8s/.uokJkrd/ikEe6wz9.b57KZryHIM69gK	t
17	user17	user17@example.com	{bcrypt}$2a$08$l5RlA120byH3oKuHvoRC7u4Tac1uSofRf9SCLEz87qH8eOL7tnAUS	t
18	user18	user18@example.com	{bcrypt}$2a$08$iiiGSvAXAjugk9qVKY2hpOBr.IorSIwR8uEZnq0YyuBBbLe4bQ/Ca	t
19	user19	user19@example.com	{bcrypt}$2a$08$pMfzVRvr9dg3k3/BnLraNu.X0JwY2eQxPYvVO5pRL4CJiGeH2DrXW	t
20	user20	user20@example.com	{bcrypt}$2a$08$UFSmlsa/lA62KzRhgZsaA.6jLoki9dCBkzW8xzl8hL.1trFFlPxsK	t
21	user21	user21@example.com	{bcrypt}$2a$08$y8m17U8weqSQknjqCS7cz.UZbt/av0XwVq.ReWWQTI15z/SlSghcy	t
22	user22	user22@example.com	{bcrypt}$2a$08$5dXJKKn.io7FA8JIAKtfsuP5X3mMVpND7/.BHvtDlK17.yqycn5IO	t
23	user23	user23@example.com	{bcrypt}$2a$08$x67dKxDcrdFd4KuX8LKKKOZSfRubcPgfrdFHASgfgbbSsMWe7KO2y	t
24	user24	user24@example.com	{bcrypt}$2a$08$DlyPYYnI6rReaxIzWfmCluuYmkTbkhdZWGQziX8/gZLMbhjwv9LNK	t
25	user25	user25@example.com	{bcrypt}$2a$08$gIL.MuVOeyeLr1VmBibajOS9.rdC2iC.7yQjT3.p.phLr5mnS/eJO	t
26	user26	user26@example.com	{bcrypt}$2a$08$xrcjsgYXN714l4.qr4Jrtuh/Tnrilk6SWAKK2yBKRZxzQr/mwmNOy	t
27	user27	user27@example.com	{bcrypt}$2a$08$ofS.w6RGZ/mGf0TsYSC0ZuRv2KJflQT4UZBDCooc2Tm11g6DmB/2C	t
28	user28	user28@example.com	{bcrypt}$2a$08$0OBRhxJW5hsbq1PlQpsmE.LROfPofXF8I5ApocL/CZpfVhJZJolOC	t
29	user29	user29@example.com	{bcrypt}$2a$08$OELaem8nik25lnM4ljy03e2Re1cuqwW7QMuPhaS3Hg7eerV9Holgy	t
30	user30	user30@example.com	{bcrypt}$2a$08$CyAQn.zwV.vvfy00lO7lZeDBcxFgJRrkdOa5GsILrPDWwFM.7xWDC	t
31	user31	user31@example.com	{bcrypt}$2a$08$.mp82O0GRxQ3JJLXBGztzubs/ydf8MA/U2YTiEnRxykDdP/E7Npxy	t
32	user32	user32@example.com	{bcrypt}$2a$08$17KquK1R.uDW0mTDPifJ8ee1o8PKEc3E5nIxSIdhyqTOTzsguYYRK	t
33	user33	user33@example.com	{bcrypt}$2a$08$Je71TRbme1AW1fUaRY1nseziPe5b76qIwo9ELaftjtrzPKm2Se29q	t
34	user34	user34@example.com	{bcrypt}$2a$08$cgIisK3RLiV9bvT2SpKd8u84ySby2EpisP2TkuJMkg8zHOD3Pu2q.	t
35	user35	user35@example.com	{bcrypt}$2a$08$gM14/ASTPKp0knMaWrfaCOHXmw5/E4tXfj1Bl8UdFu6OUaalolh5y	t
36	user36	user36@example.com	{bcrypt}$2a$08$VIV/RPWwicLYGOqvSUg5Gu0CvNCzg6yEj2GJHIf2LsCckNgG1tbyS	t
37	user37	user37@example.com	{bcrypt}$2a$08$bImR992H4WZVtj9gj7Ijxu/EvwKpEltx7cczH1oGF6yIUkAA3Rpyq	t
38	user38	user38@example.com	{bcrypt}$2a$08$3J1rcfy/7krN5He2pVqjeOJkQxkfZ/hZ4j/ZaVY1PwqjKuYAPGefC	t
39	user39	user39@example.com	{bcrypt}$2a$08$Yx.1hGxt1iwBJLjGdo.a4eYrHaaWwL5ky.ZOzZmuDFMUB2TQdYfR.	t
40	user40	user40@example.com	{bcrypt}$2a$08$NDfyYnNHJgSIRzbu1KVLaeyh7SpMaOtVoSMHiyEoES.QQcAZkv.sG	t
41	user41	user41@example.com	{bcrypt}$2a$08$OM.xss/ylr45JiLfY2FS1.9JTghmOZQkdikjDVY7DdIJRO2onlwJS	t
42	user42	user42@example.com	{bcrypt}$2a$08$2WV5HpMg6AEfXv8bWSFGUedicfmxeAeQi1UhgeupMB5..n/jqEuiy	t
43	user43	user43@example.com	{bcrypt}$2a$08$T8BFf3MgjR/7bXqYkRM6DO2tGkzHtTGQLcS8mrJde5Gh7i7DOOsw2	t
44	user44	user44@example.com	{bcrypt}$2a$08$dAvdHNDOqtZN.s/78WpAoeGZVvt3tYrmFHu8pigukJWgIRO7d8bXm	t
45	user45	user45@example.com	{bcrypt}$2a$08$Lzur8UcnS2v0d6cRbe55wetvUF.jcsgjA9z1h1n4WChernFFYBlYu	t
46	user46	user46@example.com	{bcrypt}$2a$08$wChrM971sW83/RTCsYknKeWkrzH7qQ6plA7N5n3FpBvyRyeNFB5Va	t
47	user47	user47@example.com	{bcrypt}$2a$08$Yqnwl0PGNYc.Hr6zUhG0Dec8cX4M28rk6chSYxhEBGl2WeKVB4FZi	t
48	user48	user48@example.com	{bcrypt}$2a$08$PObyKeV9zY/UAnKuwEipQOcIHFmzKN0OlDR4z9vn60DDwujr5qjdO	t
49	user49	user49@example.com	{bcrypt}$2a$08$rbL6NS8mYf3oLgnByrgU5OMZ6buyCTj9vDmB1lnWra86Y6sNvNF8u	t
50	user50	user50@example.com	{bcrypt}$2a$08$IU.7vrmb6jdu7xzQ7KPV3O89MuQjEDgRVCjTRUFHrq7bUQQAsbcYm	t
51	user51	user51@example.com	{bcrypt}$2a$08$pxFwjnDlmF6QWfAgjc7Eb.iRZt26zfJkXI3UKNXKJBWFoY/mQ0XEW	t
52	user52	user52@example.com	{bcrypt}$2a$08$eSSO/0nD2LgcFhYmbD1wpO5e4y8M3lXKUY1N8RUaP2l7STqMrVuD.	t
53	user53	user53@example.com	{bcrypt}$2a$08$49LArd7SnNOzVytF9e68zeufQQ7HUCmLbKBfGeCLQ6fV1feHX9Eri	t
59	asd3s3	aess3112	{bcrypt}$2a$10$Hu58vDYX79pPogBqFarO7.ivPcUtNQoQPrnZNipoJXKL1pxP0syxC	t
\.


--
-- Name: event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: meetnow-user
--

SELECT pg_catalog.setval('public.event_id_seq', 43, true);


--
-- Name: event_post_id_seq; Type: SEQUENCE SET; Schema: public; Owner: meetnow-user
--

SELECT pg_catalog.setval('public.event_post_id_seq', 50, true);


--
-- Name: host_id_seq; Type: SEQUENCE SET; Schema: public; Owner: meetnow-user
--

SELECT pg_catalog.setval('public.host_id_seq', 39, true);


--
-- Name: participant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: meetnow-user
--

SELECT pg_catalog.setval('public.participant_id_seq', 101, true);


--
-- Name: user_personal_data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: meetnow-user
--

SELECT pg_catalog.setval('public.user_personal_data_id_seq', 358, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: meetnow-user
--

SELECT pg_catalog.setval('public.users_id_seq', 62, true);


--
-- Name: users email_uq; Type: CONSTRAINT; Schema: public; Owner: meetnow-user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT email_uq UNIQUE (email);


--
-- Name: event event_pkey; Type: CONSTRAINT; Schema: public; Owner: meetnow-user
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_pkey PRIMARY KEY (id);


--
-- Name: event_post event_post_pkey; Type: CONSTRAINT; Schema: public; Owner: meetnow-user
--

ALTER TABLE ONLY public.event_post
    ADD CONSTRAINT event_post_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: public; Owner: meetnow-user
--

ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: host host_pkey; Type: CONSTRAINT; Schema: public; Owner: meetnow-user
--

ALTER TABLE ONLY public.host
    ADD CONSTRAINT host_pkey PRIMARY KEY (id);


--
-- Name: participant participant_pkey; Type: CONSTRAINT; Schema: public; Owner: meetnow-user
--

ALTER TABLE ONLY public.participant
    ADD CONSTRAINT participant_pkey PRIMARY KEY (id);


--
-- Name: users pk_users_id; Type: CONSTRAINT; Schema: public; Owner: meetnow-user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT pk_users_id PRIMARY KEY (id);


--
-- Name: user_personal_data user_personal_data_pkey; Type: CONSTRAINT; Schema: public; Owner: meetnow-user
--

ALTER TABLE ONLY public.user_personal_data
    ADD CONSTRAINT user_personal_data_pkey PRIMARY KEY (id);


--
-- Name: user_personal_data user_personal_data_user_id_key; Type: CONSTRAINT; Schema: public; Owner: meetnow-user
--

ALTER TABLE ONLY public.user_personal_data
    ADD CONSTRAINT user_personal_data_user_id_key UNIQUE (user_id);


--
-- Name: users username_uq; Type: CONSTRAINT; Schema: public; Owner: meetnow-user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT username_uq UNIQUE (username);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: public; Owner: meetnow-user
--

CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);


--
-- Name: host fk_host_event; Type: FK CONSTRAINT; Schema: public; Owner: meetnow-user
--

ALTER TABLE ONLY public.host
    ADD CONSTRAINT fk_host_event FOREIGN KEY (event_id) REFERENCES public.event(id);


--
-- Name: participant fk_host_event; Type: FK CONSTRAINT; Schema: public; Owner: meetnow-user
--

ALTER TABLE ONLY public.participant
    ADD CONSTRAINT fk_host_event FOREIGN KEY (event_id) REFERENCES public.event(id);


--
-- Name: host fk_host_user; Type: FK CONSTRAINT; Schema: public; Owner: meetnow-user
--

ALTER TABLE ONLY public.host
    ADD CONSTRAINT fk_host_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: participant fk_host_user; Type: FK CONSTRAINT; Schema: public; Owner: meetnow-user
--

ALTER TABLE ONLY public.participant
    ADD CONSTRAINT fk_host_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: event_post fk_post_event; Type: FK CONSTRAINT; Schema: public; Owner: meetnow-user
--

ALTER TABLE ONLY public.event_post
    ADD CONSTRAINT fk_post_event FOREIGN KEY (event_id) REFERENCES public.event(id);


--
-- Name: event_post fk_post_user; Type: FK CONSTRAINT; Schema: public; Owner: meetnow-user
--

ALTER TABLE ONLY public.event_post
    ADD CONSTRAINT fk_post_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: user_personal_data fk_user_personal_data_user_id; Type: FK CONSTRAINT; Schema: public; Owner: meetnow-user
--

ALTER TABLE ONLY public.user_personal_data
    ADD CONSTRAINT fk_user_personal_data_user_id FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

