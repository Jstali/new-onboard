--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5 (Homebrew)
-- Dumped by pg_dump version 17.5

-- Started on 2025-09-23 11:49:02 IST

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

--
-- TOC entry 4464 (class 0 OID 50650)
-- Dependencies: 274
-- Data for Name: adp_payroll; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.adp_payroll (id, employee_id, name_prefix, employee_full_name, given_or_first_name, middle_name, last_name, joining_date, payroll_starting_month, dob, aadhar, name_as_per_aadhar, designation_description, email, alternate_email, pan, name_as_per_pan, gender, department_description, work_location, labour_state_description, lwf_designation, lwf_relationship, lwf_id, professional_tax_group_description, pf_computational_group, mobile_number, phone_number1, phone_number2, address1, address2, address3, city, state, pincode, country, nationality, iw_nationality, iw_city, iw_country, coc_issuing_authority, coc_issue_date, coc_from_date, coc_upto_date, bank_name, name_as_per_bank, account_no, bank_ifsc_code, payment_mode, pf_account_no, esi_account_no, esi_above_wage_limit, uan, branch_description, enrollment_id, manager_employee_id, tax_regime, father_name, mother_name, spouse_name, marital_status, number_of_children, disability_status, type_of_disability, employment_type, grade_description, cadre_description, payment_description, attendance_description, workplace_description, band, level, work_cost_center, custom_group_1, custom_group_2, custom_group_3, custom_group_4, custom_group_5, passport_number, passport_issue_date, passport_valid_upto, passport_issued_country, visa_issuing_authority, visa_from_date, visa_upto_date, already_member_in_pf, already_member_in_pension, withdrawn_pf_and_pension, international_worker_status, relationship_for_pf, qualification, driving_licence_number, driving_licence_valid_date, pran_number, rehire, old_employee_id, is_non_payroll_employee, category_name, custom_master_name, custom_master_name2, custom_master_name3, ot_eligibility, auto_shift_eligibility, mobile_user, web_punch, attendance_exception_eligibility, attendance_exception_type, is_draft, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4416 (class 0 OID 24671)
-- Dependencies: 226
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attendance (id, employee_id, date, status, reason, clock_in_time, clock_out_time, created_at, updated_at, hours) FROM stdin;
130	153	2025-09-16	absent	\N	\N	\N	2025-09-17 12:45:42.139498	2025-09-17 12:45:42.139498	\N
132	153	2025-09-18	Work From Home	\N	\N	\N	2025-09-17 12:45:46.626166	2025-09-17 12:45:49.041148	4
133	153	2025-09-19	Half Day	\N	\N	\N	2025-09-17 12:45:51.525187	2025-09-17 12:45:53.640762	8
129	153	2025-09-15	present	\N	\N	\N	2025-09-17 12:45:39.977688	2025-09-17 12:45:57.263165	8
131	153	2025-09-17	present	\N	\N	\N	2025-09-17 12:45:44.254758	2025-09-17 12:46:01.80758	8
8	1	2025-09-04	present	\N	\N	\N	2025-09-04 14:20:33.446579	2025-09-04 14:22:23.51348	\N
137	155	2025-09-18	present	\N	\N	\N	2025-09-18 20:07:22.717101	2025-09-18 20:07:22.717101	\N
16	1	2025-09-01	present		\N	\N	2025-09-04 16:46:40.180855	2025-09-04 16:46:40.180855	\N
17	1	2025-09-02	leave		\N	\N	2025-09-04 16:47:31.343174	2025-09-04 16:47:31.343174	\N
18	1	2025-09-03	absent		\N	\N	2025-09-04 16:47:50.049928	2025-09-04 16:47:50.049928	\N
103	118	2025-09-12	present	\N	19:48:00	\N	2025-09-12 19:48:14.696158	2025-09-12 19:48:14.696158	8
111	124	2025-09-15	present	\N	\N	\N	2025-09-15 13:17:15.228358	2025-09-15 13:17:15.228358	\N
113	118	2025-09-15	present	\N	12:40:00	\N	2025-09-16 12:40:59.923393	2025-09-16 12:40:59.923393	8
114	118	2025-09-16	present	\N	12:40:00	\N	2025-09-16 12:41:01.623753	2025-09-16 12:41:01.623753	8
\.


--
-- TOC entry 4446 (class 0 OID 33058)
-- Dependencies: 256
-- Data for Name: attendance_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attendance_settings (id, setting_key, setting_value, description, created_at, updated_at) FROM stdin;
1	working_hours	8	Standard working hours per day	2025-09-03 00:47:30.659947	2025-09-03 00:47:30.659947
2	check_in_time	09:00	Standard check-in time	2025-09-03 00:47:30.659947	2025-09-03 00:47:30.659947
3	check_out_time	18:00	Standard check-out time	2025-09-03 00:47:30.659947	2025-09-03 00:47:30.659947
4	late_threshold_minutes	15	Minutes after check-in time to be considered late	2025-09-03 00:47:30.659947	2025-09-03 00:47:30.659947
5	early_leave_threshold_minutes	30	Minutes before check-out time to be considered early leave	2025-09-03 00:47:30.659947	2025-09-03 00:47:30.659947
6	allow_attendance_edit_days	7	Number of days in the past for which attendance can be edited	2025-09-03 00:47:30.659947	2025-09-03 00:47:30.659947
7	manager_edit_attendance_days	30	Number of days in the past for which managers can edit attendance	2025-09-03 00:47:30.659947	2025-09-03 00:47:30.659947
1030	allow_edit_past_days	true	Allow employees to edit attendance for past days	2025-09-04 14:59:38.588648	2025-09-04 14:59:38.588648
1031	max_edit_days	7	Maximum number of days in the past that can be edited	2025-09-04 14:59:38.588648	2025-09-04 14:59:38.588648
1032	require_check_in_time	false	Require check-in time when marking attendance	2025-09-04 14:59:38.588648	2025-09-04 14:59:38.588648
1033	require_check_out_time	false	Require check-out time when marking attendance	2025-09-04 14:59:38.588648	2025-09-04 14:59:38.588648
1034	default_work_hours	8	Default work hours per day	2025-09-04 14:59:38.588648	2025-09-04 14:59:38.588648
1035	week_start_day	monday	First day of the work week	2025-09-04 14:59:38.588648	2025-09-04 14:59:38.588648
1036	timezone	UTC	Default timezone for attendance records	2025-09-04 14:59:38.588648	2025-09-04 14:59:38.588648
1037	auto_approve_attendance	true	Automatically approve attendance submissions	2025-09-04 14:59:38.588648	2025-09-04 14:59:38.588648
1038	notification_enabled	true	Enable attendance notifications	2025-09-04 14:59:38.588648	2025-09-04 14:59:38.588648
\.


--
-- TOC entry 4430 (class 0 OID 24845)
-- Dependencies: 240
-- Data for Name: comp_off_balances; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comp_off_balances (id, employee_id, year, total_earned, comp_off_taken, comp_off_remaining, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4432 (class 0 OID 24868)
-- Dependencies: 242
-- Data for Name: company_emails; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.company_emails (id, user_id, manager_id, company_email, is_primary, is_active, created_at, updated_at) FROM stdin;
194	123	\N	srdaspradeep@nxzen.com	t	t	2025-09-15 13:35:06.246041	2025-09-15 13:35:06.246041
195	124	\N	rishitha.jaligam@nxzen.com	t	t	2025-09-15 13:35:06.249934	2025-09-15 13:35:06.249934
111	1	\N	hr@nxzen.com	t	t	2025-09-04 13:32:47.614712	2025-09-04 13:32:47.614712
205	135	\N	test@nxzen.com	t	t	2025-09-16 14:29:23.220029	2025-09-16 14:29:23.220029
206	136	\N	testnew@nxzen.com	t	t	2025-09-16 14:29:23.236174	2025-09-16 14:29:23.236174
207	137	\N	testdebug@nxzen.com	t	t	2025-09-16 14:30:10.410267	2025-09-16 14:30:10.410267
219	153	\N	mahendra@nxzen.com	t	t	2025-09-17 16:59:27.968935	2025-09-17 16:59:27.968935
221	155	\N	jstalin826@nxzen.com	t	t	2025-09-18 13:59:12.626334	2025-09-18 13:59:12.626334
190	118	\N	stalinnithin31@nxzen.com	t	t	2025-09-12 18:41:36.672494	2025-09-12 18:41:36.672494
\.


--
-- TOC entry 4426 (class 0 OID 24794)
-- Dependencies: 236
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.departments (id, name, code, description, manager_id, is_active, created_at, updated_at) FROM stdin;
1	Engineering	ENG	Software development and technical teams	\N	t	2025-09-04 03:20:17.544725	2025-09-04 03:20:17.544725
2	Product	PRD	Product management and strategy	\N	t	2025-09-04 03:20:17.544725	2025-09-04 03:20:17.544725
3	Design	DSN	UI/UX and graphic design	\N	t	2025-09-04 03:20:17.544725	2025-09-04 03:20:17.544725
4	Marketing	MKT	Marketing and communications	\N	t	2025-09-04 03:20:17.544725	2025-09-04 03:20:17.544725
5	Human Resources	HR	HR and administrative functions	\N	t	2025-09-04 03:20:17.544725	2025-09-04 03:20:17.544725
\.


--
-- TOC entry 4438 (class 0 OID 32846)
-- Dependencies: 248
-- Data for Name: document_collection; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.document_collection (id, employee_id, employee_name, emp_id, department, join_date, due_date, document_name, document_type, status, notes, uploaded_file_url, uploaded_file_name, uploaded_at, created_at, updated_at, resend_count, last_resend_date, employee_id_numeric) FROM stdin;
214	1	Test Employee	EMP001	IT	2025-09-12	2025-09-30	Resume	Required	Pending	Please upload your resume	\N	\N	\N	2025-09-12 15:46:42.325601	2025-09-12 15:46:42.325601	0	\N	\N
254	124	Rishitha Jaligam	124	N/A	2025-09-15	2025-10-15	SSC Certificate (10th)	ssc_certificate	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-15 13:09:37.11101	2025-09-15 13:09:37.11101	0	\N	\N
255	124	Rishitha Jaligam	124	N/A	2025-09-15	2025-10-15	SSC Marksheet (10th)	ssc_marksheet	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-15 13:09:37.11452	2025-09-15 13:09:37.11452	0	\N	\N
256	124	Rishitha Jaligam	124	N/A	2025-09-15	2025-10-15	HSC Certificate (12th)	hsc_certificate	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-15 13:09:37.1153	2025-09-15 13:09:37.1153	0	\N	\N
257	124	Rishitha Jaligam	124	N/A	2025-09-15	2025-10-15	HSC Marksheet (12th)	hsc_marksheet	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-15 13:09:37.116129	2025-09-15 13:09:37.116129	0	\N	\N
258	124	Rishitha Jaligam	124	N/A	2025-09-15	2025-10-15	Graduation Consolidated Marksheet	graduation_marksheet	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-15 13:09:37.116985	2025-09-15 13:09:37.116985	0	\N	\N
259	124	Rishitha Jaligam	124	N/A	2025-09-15	2025-10-15	Latest Graduation	graduation_certificate	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-15 13:09:37.117949	2025-09-15 13:09:37.117949	0	\N	\N
260	124	Rishitha Jaligam	124	N/A	2025-09-15	2025-10-15	Aadhaar Card	aadhaar	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-15 13:09:37.118678	2025-09-15 13:09:37.118678	0	\N	\N
261	124	Rishitha Jaligam	124	N/A	2025-09-15	2025-10-15	PAN Card	pan	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-15 13:09:37.119289	2025-09-15 13:09:37.119289	0	\N	\N
262	124	Rishitha Jaligam	124	N/A	2025-09-15	2025-10-15	Updated Resume	resume	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-15 13:09:37.119907	2025-09-15 13:09:37.119907	0	\N	\N
398	153	Mahendra Teja	153	N/A	2025-09-17	2025-10-17	Form 16 / Form 12B / Taxable Income Statement	form16	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-17 12:42:56.623889	2025-09-17 12:42:56.623889	0	\N	\N
399	153	Mahendra Teja	153	N/A	2025-09-17	2025-10-17	SSC Certificate (10th)	ssc_certificate	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-17 12:42:56.626312	2025-09-17 12:42:56.626312	0	\N	\N
400	153	Mahendra Teja	153	N/A	2025-09-17	2025-10-17	SSC Marksheet (10th)	ssc_marksheet	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-17 12:42:56.626852	2025-09-17 12:42:56.626852	0	\N	\N
401	153	Mahendra Teja	153	N/A	2025-09-17	2025-10-17	HSC Certificate (12th)	hsc_certificate	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-17 12:42:56.627347	2025-09-17 12:42:56.627347	0	\N	\N
402	153	Mahendra Teja	153	N/A	2025-09-17	2025-10-17	HSC Marksheet (12th)	hsc_marksheet	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-17 12:42:56.627853	2025-09-17 12:42:56.627853	0	\N	\N
403	153	Mahendra Teja	153	N/A	2025-09-17	2025-10-17	Graduation Consolidated Marksheet	graduation_marksheet	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-17 12:42:56.62832	2025-09-17 12:42:56.62832	0	\N	\N
404	153	Mahendra Teja	153	N/A	2025-09-17	2025-10-17	Latest Graduation	graduation_certificate	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-17 12:42:56.628802	2025-09-17 12:42:56.628802	0	\N	\N
405	153	Mahendra Teja	153	N/A	2025-09-17	2025-10-17	Aadhaar Card	aadhaar	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-17 12:42:56.629168	2025-09-17 12:42:56.629168	0	\N	\N
406	153	Mahendra Teja	153	N/A	2025-09-17	2025-10-17	PAN Card	pan	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-17 12:42:56.629525	2025-09-17 12:42:56.629525	0	\N	\N
407	153	Mahendra Teja	153	N/A	2025-09-17	2025-10-17	Passport	passport	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-17 12:42:56.630148	2025-09-17 12:42:56.630148	0	\N	\N
408	153	Mahendra Teja	153	N/A	2025-09-17	2025-10-17	Updated Resume	resume	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-17 12:42:56.630655	2025-09-17 12:42:56.630655	0	\N	\N
409	153	Mahendra Teja	153	N/A	2025-09-17	2025-10-17	Offer & Appointment Letter	offer_letter	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-17 12:42:56.631292	2025-09-17 12:42:56.631292	0	\N	\N
410	153	Mahendra Teja	153	N/A	2025-09-17	2025-10-17	Latest Compensation Letter	compensation_letter	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-17 12:42:56.632303	2025-09-17 12:42:56.632303	0	\N	\N
411	153	Mahendra Teja	153	N/A	2025-09-17	2025-10-17	Experience & Relieving Letter	experience_letter	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-17 12:42:56.633079	2025-09-17 12:42:56.633079	0	\N	\N
412	153	Mahendra Teja	153	N/A	2025-09-17	2025-10-17	Latest 3 Months Pay Slips	payslip	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-17 12:42:56.633862	2025-09-17 12:42:56.633862	0	\N	\N
428	155	Nithin  J	155	N/A	2025-09-18	2025-10-18	Form 16 / Form 12B / Taxable Income Statement	form16	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-18 14:28:29.353878	2025-09-18 14:28:29.353878	0	\N	\N
429	155	Nithin  J	155	N/A	2025-09-18	2025-10-18	SSC Certificate (10th)	ssc_certificate	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-18 14:28:29.357658	2025-09-18 14:28:29.357658	0	\N	\N
430	155	Nithin  J	155	N/A	2025-09-18	2025-10-18	SSC Marksheet (10th)	ssc_marksheet	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-18 14:28:29.358515	2025-09-18 14:28:29.358515	0	\N	\N
431	155	Nithin  J	155	N/A	2025-09-18	2025-10-18	HSC Certificate (12th)	hsc_certificate	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-18 14:28:29.359334	2025-09-18 14:28:29.359334	0	\N	\N
432	155	Nithin  J	155	N/A	2025-09-18	2025-10-18	HSC Marksheet (12th)	hsc_marksheet	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-18 14:28:29.360109	2025-09-18 14:28:29.360109	0	\N	\N
433	155	Nithin  J	155	N/A	2025-09-18	2025-10-18	Graduation Consolidated Marksheet	graduation_marksheet	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-18 14:28:29.360877	2025-09-18 14:28:29.360877	0	\N	\N
434	155	Nithin  J	155	N/A	2025-09-18	2025-10-18	Latest Graduation	graduation_certificate	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-18 14:28:29.361968	2025-09-18 14:28:29.361968	0	\N	\N
435	155	Nithin  J	155	N/A	2025-09-18	2025-10-18	Aadhaar Card	aadhaar	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-18 14:28:29.363006	2025-09-18 14:28:29.363006	0	\N	\N
436	155	Nithin  J	155	N/A	2025-09-18	2025-10-18	PAN Card	pan	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-18 14:28:29.363877	2025-09-18 14:28:29.363877	0	\N	\N
437	155	Nithin  J	155	N/A	2025-09-18	2025-10-18	Passport	passport	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-18 14:28:29.364444	2025-09-18 14:28:29.364444	0	\N	\N
438	155	Nithin  J	155	N/A	2025-09-18	2025-10-18	Updated Resume	resume	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-18 14:28:29.365079	2025-09-18 14:28:29.365079	0	\N	\N
439	155	Nithin  J	155	N/A	2025-09-18	2025-10-18	Offer & Appointment Letter	offer_letter	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-18 14:28:29.365673	2025-09-18 14:28:29.365673	0	\N	\N
440	155	Nithin  J	155	N/A	2025-09-18	2025-10-18	Latest Compensation Letter	compensation_letter	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-18 14:28:29.366267	2025-09-18 14:28:29.366267	0	\N	\N
441	155	Nithin  J	155	N/A	2025-09-18	2025-10-18	Experience & Relieving Letter	experience_letter	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-18 14:28:29.36678	2025-09-18 14:28:29.36678	0	\N	\N
442	155	Nithin  J	155	N/A	2025-09-18	2025-10-18	Latest 3 Months Pay Slips	payslip	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-18 14:28:29.367275	2025-09-18 14:28:29.367275	0	\N	\N
383	123	Pradeep test 1	123	N/A	2025-09-17	2025-10-17	Form 16 / Form 12B / Taxable Income Statement	form16	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-17 12:42:53.59809	2025-09-17 12:42:53.59809	0	\N	\N
384	123	Pradeep test 1	123	N/A	2025-09-17	2025-10-17	SSC Certificate (10th)	ssc_certificate	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-17 12:42:53.602337	2025-09-17 12:42:53.602337	0	\N	\N
385	123	Pradeep test 1	123	N/A	2025-09-17	2025-10-17	SSC Marksheet (10th)	ssc_marksheet	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-17 12:42:53.603634	2025-09-17 12:42:53.603634	0	\N	\N
386	123	Pradeep test 1	123	N/A	2025-09-17	2025-10-17	HSC Certificate (12th)	hsc_certificate	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-17 12:42:53.604563	2025-09-17 12:42:53.604563	0	\N	\N
387	123	Pradeep test 1	123	N/A	2025-09-17	2025-10-17	HSC Marksheet (12th)	hsc_marksheet	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-17 12:42:53.605459	2025-09-17 12:42:53.605459	0	\N	\N
388	123	Pradeep test 1	123	N/A	2025-09-17	2025-10-17	Graduation Consolidated Marksheet	graduation_marksheet	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-17 12:42:53.606543	2025-09-17 12:42:53.606543	0	\N	\N
389	123	Pradeep test 1	123	N/A	2025-09-17	2025-10-17	Latest Graduation	graduation_certificate	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-17 12:42:53.607677	2025-09-17 12:42:53.607677	0	\N	\N
390	123	Pradeep test 1	123	N/A	2025-09-17	2025-10-17	Aadhaar Card	aadhaar	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-17 12:42:53.608399	2025-09-17 12:42:53.608399	0	\N	\N
308	118	Luthen S	118	N/A	2025-09-16	2025-10-16	Form 16 / Form 12B / Taxable Income Statement	form16	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-16 19:42:56.985943	2025-09-16 19:42:56.985943	0	\N	\N
391	123	Pradeep test 1	123	N/A	2025-09-17	2025-10-17	PAN Card	pan	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-17 12:42:53.609325	2025-09-17 12:42:53.609325	0	\N	\N
392	123	Pradeep test 1	123	N/A	2025-09-17	2025-10-17	Passport	passport	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-17 12:42:53.610029	2025-09-17 12:42:53.610029	0	\N	\N
393	123	Pradeep test 1	123	N/A	2025-09-17	2025-10-17	Updated Resume	resume	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-17 12:42:53.610828	2025-09-17 12:42:53.610828	0	\N	\N
394	123	Pradeep test 1	123	N/A	2025-09-17	2025-10-17	Offer & Appointment Letter	offer_letter	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-17 12:42:53.61136	2025-09-17 12:42:53.61136	0	\N	\N
395	123	Pradeep test 1	123	N/A	2025-09-17	2025-10-17	Latest Compensation Letter	compensation_letter	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-17 12:42:53.611903	2025-09-17 12:42:53.611903	0	\N	\N
396	123	Pradeep test 1	123	N/A	2025-09-17	2025-10-17	Experience & Relieving Letter	experience_letter	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-17 12:42:53.612516	2025-09-17 12:42:53.612516	0	\N	\N
397	123	Pradeep test 1	123	N/A	2025-09-17	2025-10-17	Latest 3 Months Pay Slips	payslip	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-17 12:42:53.613966	2025-09-17 12:42:53.613966	0	\N	\N
309	118	Luthen S	118	N/A	2025-09-16	2025-10-16	SSC Certificate (10th)	ssc_certificate	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-16 19:42:56.990483	2025-09-16 19:42:56.990483	0	\N	\N
310	118	Luthen S	118	N/A	2025-09-16	2025-10-16	SSC Marksheet (10th)	ssc_marksheet	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-16 19:42:56.991606	2025-09-16 19:42:56.991606	0	\N	\N
311	118	Luthen S	118	N/A	2025-09-16	2025-10-16	HSC Certificate (12th)	hsc_certificate	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-16 19:42:56.992729	2025-09-16 19:42:56.992729	0	\N	\N
312	118	Luthen S	118	N/A	2025-09-16	2025-10-16	HSC Marksheet (12th)	hsc_marksheet	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-16 19:42:56.993507	2025-09-16 19:42:56.993507	0	\N	\N
313	118	Luthen S	118	N/A	2025-09-16	2025-10-16	Graduation Consolidated Marksheet	graduation_marksheet	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-16 19:42:56.994224	2025-09-16 19:42:56.994224	0	\N	\N
314	118	Luthen S	118	N/A	2025-09-16	2025-10-16	Latest Graduation	graduation_certificate	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-16 19:42:56.995092	2025-09-16 19:42:56.995092	0	\N	\N
315	118	Luthen S	118	N/A	2025-09-16	2025-10-16	Aadhaar Card	aadhaar	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-16 19:42:56.995868	2025-09-16 19:42:56.995868	0	\N	\N
316	118	Luthen S	118	N/A	2025-09-16	2025-10-16	PAN Card	pan	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-16 19:42:56.996598	2025-09-16 19:42:56.996598	0	\N	\N
317	118	Luthen S	118	N/A	2025-09-16	2025-10-16	Passport	passport	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-16 19:42:56.997194	2025-09-16 19:42:56.997194	0	\N	\N
318	118	Luthen S	118	N/A	2025-09-16	2025-10-16	Updated Resume	resume	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-16 19:42:56.997746	2025-09-16 19:42:56.997746	0	\N	\N
319	118	Luthen S	118	N/A	2025-09-16	2025-10-16	Offer & Appointment Letter	offer_letter	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-16 19:42:56.998257	2025-09-16 19:42:56.998257	0	\N	\N
320	118	Luthen S	118	N/A	2025-09-16	2025-10-16	Latest Compensation Letter	compensation_letter	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-16 19:42:56.998753	2025-09-16 19:42:56.998753	0	\N	\N
321	118	Luthen S	118	N/A	2025-09-16	2025-10-16	Experience & Relieving Letter	experience_letter	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-16 19:42:56.999301	2025-09-16 19:42:56.999301	0	\N	\N
322	118	Luthen S	118	N/A	2025-09-16	2025-10-16	Latest 3 Months Pay Slips	payslip	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-16 19:42:56.999789	2025-09-16 19:42:56.999789	0	\N	\N
\.


--
-- TOC entry 4458 (class 0 OID 50359)
-- Dependencies: 268
-- Data for Name: document_reminder_mails; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.document_reminder_mails (id, employee_id, employee_email, employee_name, sent_by_hr_id, sent_by_hr_name, sent_at, document_upload_link, status, created_at) FROM stdin;
\.


--
-- TOC entry 4440 (class 0 OID 32864)
-- Dependencies: 250
-- Data for Name: document_templates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.document_templates (id, document_name, document_type, description, is_active, created_at, updated_at, category, is_required, allow_multiple) FROM stdin;
9	Passport Size Photographs	Required	Recent passport size photographs	t	2025-09-01 08:21:28.000725	2025-09-01 08:21:28.000725	\N	f	f
6	Form 16 / Form 12B / Taxable Income Statement	form16	Tax-related documents for income verification	t	2025-09-01 08:21:28.000725	2025-09-02 23:19:19.806183	employment	f	f
2383	SSC Certificate (10th)	ssc_certificate	Secondary School Certificate for 10th standard	t	2025-09-01 19:12:26.889746	2025-09-02 23:19:19.806572	education	f	f
2384	SSC Marksheet (10th)	ssc_marksheet	Secondary School Certificate marksheet for 10th standard	t	2025-09-01 19:12:26.889746	2025-09-02 23:19:19.806851	education	f	f
2385	HSC Certificate (12th)	hsc_certificate	Higher Secondary Certificate for 12th standard	t	2025-09-01 19:12:26.889746	2025-09-02 23:19:19.807216	education	f	f
2386	HSC Marksheet (12th)	hsc_marksheet	Higher Secondary Certificate marksheet for 12th standard	t	2025-09-01 19:12:26.889746	2025-09-02 23:19:19.807563	education	f	f
2387	Graduation Consolidated Marksheet	graduation_marksheet	Graduation consolidated marksheet	t	2025-09-01 19:12:26.889746	2025-09-02 23:19:19.808054	education	f	f
4665	Latest Graduation	graduation_certificate	Latest graduation certificate	t	2025-09-04 00:22:53.670433	2025-09-04 00:22:53.670433	education	t	f
2389	Post-Graduation Marksheet	postgrad_marksheet	Post-graduation marksheet if applicable	t	2025-09-01 19:12:26.889746	2025-09-02 23:19:19.808687	education	f	f
2390	Post-Graduation Certificate	postgrad_certificate	Post-graduation certificate if applicable	t	2025-09-01 19:12:26.889746	2025-09-02 23:19:19.808935	education	f	f
8	Aadhaar Card	aadhaar	Aadhaar card for identity verification	t	2025-09-01 08:21:28.000725	2025-09-02 23:19:19.809179	identity	t	f
7	PAN Card	pan	Permanent Account Number card for tax purposes	t	2025-09-01 08:21:28.000725	2025-09-02 23:19:19.809436	identity	t	f
2393	Passport	passport	Passport for identity verification	t	2025-09-01 19:12:26.889746	2025-09-02 23:19:19.80966	identity	f	f
10	Address Proof	address_proof	Valid address proof document	t	2025-09-01 08:21:28.000725	2025-09-02 23:19:19.809868	identity	f	f
11	Educational Certificates	educational_certificates	Relevant educational qualification certificates	t	2025-09-01 08:21:28.000725	2025-09-02 23:19:19.810117	education	f	t
12	Professional Certifications	professional_certifications	Professional certifications and training documents	t	2025-09-01 08:21:28.000725	2025-09-02 23:19:19.810437	employment	f	t
9340	Cancelled Checkbook	cancelled_checkbook	Cancelled checkbook for bank account verification	t	2025-09-10 15:58:29.247488	2025-09-10 15:58:29.247488	employment	f	f
2388	Graduation Original/Provisional Certificate	graduation_certificate	Graduation original or provisional certificate	t	2025-09-01 19:12:26.889746	2025-09-02 23:19:19.808357	education	f	f
1	Updated Resume	resume	Current resume with latest experience and skills	t	2025-09-01 08:21:28.000725	2025-09-02 23:19:19.796299	employment	f	f
2	Offer & Appointment Letter	offer_letter	Official offer letter and appointment confirmation	t	2025-09-01 08:21:28.000725	2025-09-02 23:19:19.804258	employment	f	f
3	Latest Compensation Letter	compensation_letter	Most recent salary and compensation details	t	2025-09-01 08:21:28.000725	2025-09-02 23:19:19.804985	employment	f	f
4	Experience & Relieving Letter	experience_letter	Previous employment experience and relieving letter	t	2025-09-01 08:21:28.000725	2025-09-02 23:19:19.805343	employment	f	f
5	Latest 3 Months Pay Slips	payslip	Pay slips from the last 3 months of previous employment	t	2025-09-01 08:21:28.000725	2025-09-02 23:19:19.805684	employment	f	t
\.


--
-- TOC entry 4470 (class 0 OID 50732)
-- Dependencies: 280
-- Data for Name: documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.documents (id, employee_id, document_type, file_name, file_path, file_size, mime_type, status, uploaded_by, reviewed_by, reviewed_at, review_notes, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4428 (class 0 OID 24825)
-- Dependencies: 238
-- Data for Name: employee_documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_documents (id, employee_id, document_type, document_category, file_name, file_url, file_size, mime_type, is_required, uploaded_at, updated_at, resend_count, last_resend_date, status) FROM stdin;
76	123	graduation_certificate	education	Screenshot 2025-09-09 at 5.54.11â¯PM.png	uploads/documents/documents-1757920929989-399220850.png	87707	image/png	f	2025-09-15 12:52:09.998464	2025-09-15 12:52:09.998464	0	\N	pending
77	123	aadhaar	identity	Screenshot 2025-09-15 at 12.45.48â¯PM (2).png	uploads/documents/documents-1757920935990-323658694.png	182262	image/png	f	2025-09-15 12:52:15.993908	2025-09-15 12:52:15.993908	0	\N	pending
78	123	pan	identity	Screenshot 2025-09-09 at 7.10.41â¯PM.png	uploads/documents/documents-1757920944441-64753311.png	878933	image/png	f	2025-09-15 12:52:24.449198	2025-09-15 12:52:24.449198	0	\N	pending
79	124	graduation_certificate	education	Screenshot 2025-09-10 at 4.31.14â¯PM.png	uploads/documents/documents-1757921890833-41908495.png	36072	image/png	f	2025-09-15 13:08:10.838788	2025-09-15 13:08:10.838788	0	\N	pending
80	124	aadhaar	identity	Screenshot 2025-09-10 at 4.31.14â¯PM.png	uploads/documents/documents-1757921896026-885841530.png	36072	image/png	f	2025-09-15 13:08:16.027882	2025-09-15 13:08:16.027882	0	\N	pending
81	124	pan	identity	Screenshot 2025-09-09 at 7.10.41â¯PM.png	uploads/documents/documents-1757921899416-578800975.png	878933	image/png	f	2025-09-15 13:08:19.420598	2025-09-15 13:08:19.420598	0	\N	pending
105	153	graduation_certificate	education	1-31c767cf-bed8-47f6-8d9f-ebc55c4a76ef-1.pdf	uploads/documents/documents-1758093101071-465273870.pdf	120848	application/pdf	f	2025-09-17 12:41:41.078863	2025-09-17 12:41:41.078863	0	\N	pending
106	153	aadhaar	identity	1-a0a2d4c7-0bc6-4c06-900e-0db6f449656e.pdf	uploads/documents/documents-1758093107976-383873921.pdf	120461	application/pdf	f	2025-09-17 12:41:47.979334	2025-09-17 12:41:47.979334	0	\N	pending
107	153	pan	identity	1-230ed728-bd80-4ed7-ab27-a68b0e5a1cb3.pdf	uploads/documents/documents-1758093114108-818766209.pdf	120795	application/pdf	f	2025-09-17 12:41:54.115941	2025-09-17 12:41:54.115941	0	\N	pending
111	155	graduation_certificate	education	1-33b22d5d-40e9-44fb-b7d9-8d2c8eeca29c.pdf	uploads/documents/documents-1758184994253-171468195.pdf	120644	application/pdf	f	2025-09-18 14:13:14.257538	2025-09-18 14:13:14.257538	0	\N	pending
112	155	aadhaar	identity	1-a0a2d4c7-0bc6-4c06-900e-0db6f449656e.pdf	uploads/documents/documents-1758185004358-316513369.pdf	120461	application/pdf	f	2025-09-18 14:13:24.362209	2025-09-18 14:13:24.362209	0	\N	pending
113	155	pan	identity	1-230ed728-bd80-4ed7-ab27-a68b0e5a1cb3.pdf	uploads/documents/documents-1758185012613-719649167.pdf	120795	application/pdf	f	2025-09-18 14:13:32.617958	2025-09-18 14:13:32.617958	0	\N	pending
\.


--
-- TOC entry 4452 (class 0 OID 42957)
-- Dependencies: 262
-- Data for Name: employee_forms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_forms (id, employee_id, type, form_data, files, status, submitted_at, updated_at, reviewed_by, reviewed_at, review_notes, draft_data, documents_uploaded, assigned_manager, manager2_name, manager3_name, employee_type) FROM stdin;
6	123	Full-Time	{"name": "Test User Updated", "email": "test@example.com", "phone": "1234567890"}	{}	approved	2025-09-17 12:42:53.569202	2025-09-17 12:42:53.569202	\N	\N	\N	\N	\N	\N	\N	\N	\N
7	124	Intern	{"doj": "2025-09-16", "name": "Jaliga", "email": "jaligamrishitha@gmail.com", "phone": "6567567576", "address": "45 Oceanview Drive, Miami, FL 33101", "education": "MBA, University of Miami, 2020", "experience": "", "submittedAt": "2025-09-15T07:37:52.460Z", "emergencyContact": {"name": "Carlos Ramirez", "phone": "3055554567", "relationship": "Brother"}, "emergencyContact2": {"name": "Maria Ramirez", "phone": "5765765765", "relationship": "Father"}}	{}	approved	2025-09-15 13:09:37.102993	2025-09-15 13:09:37.102993	\N	\N	\N	\N	\N	\N	\N	\N	\N
36	153	Full-Time	{"doj": "", "name": "Mahendra Teja", "email": "mahendratejak8@gmail.com", "phone": "9876543456", "address": "RTFCgvhbj", "education": "RTDfygubh", "experience": "", "submittedAt": "2025-09-17T07:11:05.092Z", "emergencyContact": {"name": "rtfyvgbjh", "phone": "9876544567", "relationship": "fghj"}, "emergencyContact2": {"name": "xdfgvbhnj", "phone": "4567898745", "relationship": "erfghj"}}	{}	approved	2025-09-17 12:42:56.612817	2025-09-17 12:42:56.612817	\N	\N	\N	\N	\N	\N	\N	\N	\N
38	155	Full-Time	{"doj": "2025-09-24", "name": "Nithin J", "email": "jstalin826@gmail.com", "phone": "7678465897", "address": "test", "education": "test", "experience": "", "submittedAt": "2025-09-18T08:55:35.271Z", "emergencyContact": {"name": "Nis", "phone": "7564876387", "relationship": "Brother"}, "emergencyContact2": {"name": "Anish", "phone": "7567467346", "relationship": "Friend"}}	{}	approved	2025-09-18 14:28:29.335772	2025-09-18 18:51:51.710831	\N	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- TOC entry 4412 (class 0 OID 24639)
-- Dependencies: 222
-- Data for Name: employee_master; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_master (id, employee_id, employee_name, company_email, manager_id, manager_name, type, role, doj, status, department, designation, salary_band, location, created_at, updated_at, department_id, manager2_id, manager2_name, manager3_id, manager3_name, employee_id_numeric, manager_id_numeric, manager2_id_numeric, manager3_id_numeric, email) FROM stdin;
113	125631	Pradeep test 1	srdaspradeep@gmail.com	\N	\N	Full-Time	\N	2025-09-16	active	\N	\N	\N	\N	2025-09-16 14:17:47.274207	2025-09-16 14:17:47.274207	\N	\N	\N	\N	\N	\N	\N	\N	\N	srdaspradeep@gmail.com
45	aa142d	Luthen S	stalinnithin31@gmail.com	\N	\N	Manager	\N	2025-09-12	active	\N	\N	\N	\N	2025-09-12 18:34:28.771547	2025-09-12 18:34:28.771547	\N	\N	\N	\N	\N	\N	\N	\N	\N	stalinnithin31@gmail.com
145	678647	Nithin  J	nithin@nxzen.com	aa142d	Luthen S	Full-Time	\N	2025-09-24	active	\N	\N	\N	\N	2025-09-18 14:29:02.098893	2025-09-18 14:29:02.098893	\N	\N	\N	\N	\N	\N	\N	\N	\N	jstalin826@gmail.com
51	692539	Risitha	rishitha.jaligam@nxzen.com	aa142d	Luthen S	Intern	\N	2025-09-16	active	\N	\N	\N	\N	2025-09-15 13:11:31.605265	2025-09-15 13:11:31.605265	\N	\N	\N	\N	\N	\N	\N	\N	\N	jaligamrishitha@gmail.com
141	256409	Mahendra Teja	mahendra@nxzen.com	aa142d	Luthen S	Full-Time	\N	2025-09-17	active	\N	\N	\N	\N	2025-09-17 12:43:41.24581	2025-09-17 12:43:41.24581	\N	\N	\N	\N	\N	\N	\N	\N	\N	mahendratejak8@gmail.com
\.


--
-- TOC entry 4460 (class 0 OID 50458)
-- Dependencies: 270
-- Data for Name: employees_combined; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employees_combined (id, employee_id, employee_name, company_email, manager_id, manager_name, manager2_id, manager2_name, manager3_id, manager3_name, type, role, doj, status, department, designation, salary_band, location, name_prefix, employee_full_name, given_or_first_name, middle_name, last_name, joining_date, payroll_starting_month, dob, aadhar, name_as_per_aadhar, designation_description, email, alternate_email, pan, name_as_per_pan, gender, department_description, work_location, labour_state_description, lwf_designation, lwf_relationship, lwf_id, professional_tax_group_description, pf_computational_group, mobile_number, phone_number1, phone_number2, address1, address2, address3, city, state, pincode, country, nationality, iw_nationality, iw_city, iw_country, coc_issuing_authority, coc_issue_date, coc_from_date, coc_upto_date, bank_name, name_as_per_bank, account_no, bank_ifsc_code, payment_mode, pf_account_no, esi_account_no, esi_above_wage_limit, disability_status, already_member_in_pf, pf_opt_out, esi_opt_out, international_worker_status, relationship_for_pf, qualification, driving_licence_number, driving_licence_valid_date, pran_number, rehire, old_employee_id, is_non_payroll_employee, category_name, custom_master_name, custom_master_name2, custom_master_name3, ot_eligibility, auto_shift_eligibility, mobile_user, web_punch, attendance_exception_eligibility, attendance_exception_type, is_draft, created_at, updated_at) FROM stdin;
2	590350	Hughie S	hughie.s@nxzen.com	aa142d	Luthen S	\N	\N	\N	\N	Full-Time	\N	2025-09-22	active	\N	\N	\N	\N	\N	Hughie 	\N	\N	\N	2025-09-23	\N	2001-09-04	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	f	f	\N	\N	f	\N	\N	\N	\N	\N	f	\N	f	\N	\N	\N	\N	f	f	f	f	f	\N	f	2025-09-13 20:12:55.773	2025-09-13 20:12:55.773
1	272971	Butcher W	strawhatluff124@gmail.com	aa142d	Luthen S	\N	\N	\N	\N	Full-Time	\N	2025-09-16	active	Engineering	Senior Developer	L3	\N	\N	Butcher W	\N	\N	\N	2025-09-23	2025-09-01	2001-09-04	665675764576	Butcher William	\N	\N	\N	\N	\N	Male	\N	Bangalore Office	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	f	f	\N	\N	f	\N	\N	\N	\N	\N	f	\N	f	\N	\N	\N	\N	f	f	f	f	f	\N	f	2025-09-14 09:39:48.518	2025-09-14 14:33:20.611
6	978408	Stalin J	stalin@nxzen.com	aa142d	Luthen S	\N	\N	\N	\N	Full-Time	\N	2025-09-17	active	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	f	f	f	f	f	\N	\N	\N	\N	\N	f	\N	f	\N	\N	\N	\N	f	f	f	f	f	\N	f	2025-09-18 12:41:20.152763	2025-09-18 12:42:34.513987
8	256409	Mahendra Teja	mahendra@nxzen.com	aa142d	Luthen S	\N	\N	\N	\N	Full-Time	\N	2025-09-17	active	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	f	f	f	f	f	\N	\N	\N	\N	\N	f	\N	f	\N	\N	\N	\N	f	f	f	f	f	\N	f	2025-09-18 12:42:34.51511	2025-09-18 12:42:34.51511
9	125631	Pradeep test 1	srdaspradeep@gmail.com	\N	\N	\N	\N	\N	\N	Full-Time	\N	2025-09-16	active	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	f	f	f	f	f	\N	\N	\N	\N	\N	f	\N	f	\N	\N	\N	\N	f	f	f	f	f	\N	f	2025-09-18 12:42:34.516084	2025-09-18 12:42:34.516084
10	692539	Risitha	rishitha.jaligam@nxzen.com	aa142d	Luthen S	\N	\N	\N	\N	Intern	\N	2025-09-16	active	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	f	f	f	f	f	\N	\N	\N	\N	\N	f	\N	f	\N	\N	\N	\N	f	f	f	f	f	\N	f	2025-09-18 12:42:34.517162	2025-09-18 12:42:34.517162
4	aa142d	Luthen S	stalinnithin31@gmail.com	\N	\N	\N	\N	\N	\N	Manager	\N	2025-09-12	active	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	2025-09-12 18:34:28.771	2025-09-18 12:42:34.517725
\.


--
-- TOC entry 4436 (class 0 OID 32803)
-- Dependencies: 246
-- Data for Name: expense_attachments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.expense_attachments (id, expense_id, file_name, file_url, file_size, mime_type, uploaded_at) FROM stdin;
\.


--
-- TOC entry 4466 (class 0 OID 50690)
-- Dependencies: 276
-- Data for Name: expense_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.expense_categories (id, name, description, is_active, created_at, updated_at) FROM stdin;
1	Travel	Travel and transportation expenses	t	2025-09-16 13:01:18.504429	2025-09-16 13:01:18.504429
2	Meals	Business meal expenses	t	2025-09-16 13:01:18.504429	2025-09-16 13:01:18.504429
3	Office Supplies	Office supplies and equipment	t	2025-09-16 13:01:18.504429	2025-09-16 13:01:18.504429
4	Training	Training and development expenses	t	2025-09-16 13:01:18.504429	2025-09-16 13:01:18.504429
5	Communication	Phone and internet expenses	t	2025-09-16 13:01:18.504429	2025-09-16 13:01:18.504429
6	Others	Miscellaneous expenses	t	2025-09-16 13:01:18.504429	2025-09-16 13:01:18.504429
\.


--
-- TOC entry 4468 (class 0 OID 50704)
-- Dependencies: 278
-- Data for Name: expense_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.expense_requests (id, employee_id, category_id, amount, description, expense_date, receipt_url, status, approved_by, approved_at, approval_notes, created_at, updated_at) FROM stdin;
1	1	1	1500.00	Client meeting travel	2025-09-15	\N	approved	1	2025-09-17 11:20:55.691039	\N	2025-09-17 11:20:55.691039	2025-09-17 11:20:55.691039
2	1	2	800.00	Business lunch	2025-09-14	\N	approved	1	2025-09-17 11:20:55.691039	\N	2025-09-17 11:20:55.691039	2025-09-17 11:20:55.691039
3	1	3	2500.00	Office supplies	2025-09-13	\N	approved	1	2025-09-17 11:20:55.691039	\N	2025-09-17 11:20:55.691039	2025-09-17 11:20:55.691039
4	1	4	5001.00	Training course	2025-09-12	\N	approved	1	2025-09-17 11:20:55.691039	\N	2025-09-17 11:20:55.691039	2025-09-17 11:20:55.691039
5	1	5	1200.00	Internet bill	2025-09-11	\N	approved	1	2025-09-17 11:20:55.691039	\N	2025-09-17 11:20:55.691039	2025-09-17 11:20:55.691039
6	1	1	2000.00	Conference travel	2025-08-20	\N	approved	1	2025-09-17 11:21:14.955846	\N	2025-09-17 11:21:14.955846	2025-09-17 11:21:14.955846
7	1	2	1200.00	Team dinner	2025-08-15	\N	approved	1	2025-09-17 11:21:14.955846	\N	2025-09-17 11:21:14.955846	2025-09-17 11:21:14.955846
8	1	3	1800.00	Software license	2025-08-10	\N	approved	1	2025-09-17 11:21:14.955846	\N	2025-09-17 11:21:14.955846	2025-09-17 11:21:14.955846
9	1	4	3001.00	Certification exam	2025-07-25	\N	approved	1	2025-09-17 11:21:14.955846	\N	2025-09-17 11:21:14.955846	2025-09-17 11:21:14.955846
10	1	5	900.00	Phone bill	2025-07-20	\N	approved	1	2025-09-17 11:21:14.955846	\N	2025-09-17 11:21:14.955846	2025-09-17 11:21:14.955846
11	1	6	1500.00	Miscellaneous	2025-07-15	\N	approved	1	2025-09-17 11:21:14.955846	\N	2025-09-17 11:21:14.955846	2025-09-17 11:21:14.955846
12	137	1	3001.00	Client visit travel	2025-09-10	\N	approved	1	2025-09-17 11:21:44.495239	\N	2025-09-17 11:21:44.495239	2025-09-17 11:21:44.495239
13	137	2	1500.00	Client meeting lunch	2025-09-08	\N	approved	1	2025-09-17 11:21:44.495239	\N	2025-09-17 11:21:44.495239	2025-09-17 11:21:44.495239
\.


--
-- TOC entry 4434 (class 0 OID 32769)
-- Dependencies: 244
-- Data for Name: expenses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.expenses (id, series, employee_id, employee_name, expense_category, expense_type, other_category, amount, currency, description, attachment_url, attachment_name, expense_date, project_reference, payment_mode, tax_included, total_reimbursable, status, manager1_id, manager1_name, manager1_status, manager1_approved_at, manager1_approval_notes, manager2_id, manager2_name, manager2_status, manager2_approved_at, manager2_approval_notes, manager3_id, manager3_name, manager3_status, manager3_approved_at, manager3_approval_notes, hr_id, hr_name, hr_approved_at, hr_approval_notes, approval_token, created_at, updated_at, client_code) FROM stdin;
\.


--
-- TOC entry 4422 (class 0 OID 24733)
-- Dependencies: 232
-- Data for Name: leave_balances; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.leave_balances (id, employee_id, year, total_allocated, leaves_taken, leaves_remaining, created_at, updated_at) FROM stdin;
2	1	2025	15	0	15	2025-09-04 10:56:56.180234	2025-09-09 19:24:33.225864
23	118	2025	15	0	15	2025-09-16 12:41:18.848259	2025-09-16 12:41:18.848259
27	153	2025	15	0	15	2025-09-17 12:46:16.39094	2025-09-17 12:46:16.39094
\.


--
-- TOC entry 4418 (class 0 OID 24689)
-- Dependencies: 228
-- Data for Name: leave_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.leave_requests (id, series, employee_id, employee_name, leave_type, leave_balance_before, from_date, to_date, half_day, total_leave_days, reason, status, manager_approved_at, manager_approval_notes, hr_id, hr_name, hr_approved_at, hr_approval_notes, approval_token, created_at, updated_at, manager1_id, manager1_name, manager1_status, manager2_id, manager2_name, manager2_status, manager3_id, manager3_name, manager3_status, approved_by, approved_at, approval_notes, role) FROM stdin;
6	LR-MF561R38-781XI	1	HR Manager	Sick Leave	15.0	2024-02-01	2024-02-03	f	3.0	Not feeling well	rejected	\N	\N	1	HR Manager	2025-09-08 12:59:57.772043		d8aa64375ecc15a48795da7771405446b3d4a6a2d270400eb9e6be4d670b60b6	2025-09-04 14:20:35.498759	2025-09-08 12:59:57.772043	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	employee
7	LR-MF564406-E5SG9	1	HR Manager	Sick Leave	15.0	2024-02-01	2024-02-03	f	3.0	Not feeling well	rejected	\N	\N	1	HR Manager	2025-09-12 19:52:54.598212		459e028268d3c57f1b9c5f5b9cafc1f94bae23c89768313bca7066fafcbc429c	2025-09-04 14:22:25.546671	2025-09-12 19:52:54.598212	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	employee
\.


--
-- TOC entry 4442 (class 0 OID 32901)
-- Dependencies: 252
-- Data for Name: leave_type_balances; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.leave_type_balances (id, employee_id, year, leave_type, total_allocated, leaves_taken, leaves_remaining, created_at, updated_at) FROM stdin;
1	624562	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-01 13:44:45.370703	2025-09-01 13:44:45.370703
2	624562	2025	Sick Leave	3.00	0.00	3.00	2025-09-01 13:44:45.370703	2025-09-01 13:44:45.370703
3	624562	2025	Casual Leave	3.00	0.00	3.00	2025-09-01 13:44:45.370703	2025-09-01 13:44:45.370703
4	950792	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-01 13:44:45.379303	2025-09-01 13:44:45.379303
5	950792	2025	Sick Leave	3.00	0.00	3.00	2025-09-01 13:44:45.379303	2025-09-01 13:44:45.379303
6	950792	2025	Casual Leave	3.00	0.00	3.00	2025-09-01 13:44:45.379303	2025-09-01 13:44:45.379303
7	333333	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-01 13:44:45.382026	2025-09-01 13:44:45.382026
8	333333	2025	Sick Leave	3.00	0.00	3.00	2025-09-01 13:44:45.382026	2025-09-01 13:44:45.382026
9	333333	2025	Casual Leave	3.00	0.00	3.00	2025-09-01 13:44:45.382026	2025-09-01 13:44:45.382026
10	26	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-01 13:45:10.605281	2025-09-01 13:45:10.605281
11	26	2025	Sick Leave	3.00	0.00	3.00	2025-09-01 13:45:10.605281	2025-09-01 13:45:10.605281
12	26	2025	Casual Leave	3.00	0.00	3.00	2025-09-01 13:45:10.605281	2025-09-01 13:45:10.605281
13	27	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-01 13:45:10.609559	2025-09-01 13:45:10.609559
14	27	2025	Sick Leave	3.00	0.00	3.00	2025-09-01 13:45:10.609559	2025-09-01 13:45:10.609559
15	27	2025	Casual Leave	3.00	0.00	3.00	2025-09-01 13:45:10.609559	2025-09-01 13:45:10.609559
16	25	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-01 13:45:10.61235	2025-09-01 13:45:10.61235
17	25	2025	Sick Leave	3.00	0.00	3.00	2025-09-01 13:45:10.61235	2025-09-01 13:45:10.61235
18	25	2025	Casual Leave	3.00	0.00	3.00	2025-09-01 13:45:10.61235	2025-09-01 13:45:10.61235
19	28	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-01 13:45:10.61461	2025-09-01 13:45:10.61461
20	28	2025	Sick Leave	3.00	0.00	3.00	2025-09-01 13:45:10.61461	2025-09-01 13:45:10.61461
22	30	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-01 13:45:10.616971	2025-09-01 13:45:10.616971
23	30	2025	Sick Leave	3.00	0.00	3.00	2025-09-01 13:45:10.616971	2025-09-01 13:45:10.616971
24	30	2025	Casual Leave	3.00	0.00	3.00	2025-09-01 13:45:10.616971	2025-09-01 13:45:10.616971
25	24	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-01 13:45:10.619347	2025-09-01 13:45:10.619347
26	24	2025	Sick Leave	3.00	0.00	3.00	2025-09-01 13:45:10.619347	2025-09-01 13:45:10.619347
27	24	2025	Casual Leave	3.00	0.00	3.00	2025-09-01 13:45:10.619347	2025-09-01 13:45:10.619347
28	16	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-01 13:45:10.621784	2025-09-01 13:45:10.621784
29	16	2025	Sick Leave	3.00	0.00	3.00	2025-09-01 13:45:10.621784	2025-09-01 13:45:10.621784
30	16	2025	Casual Leave	3.00	0.00	3.00	2025-09-01 13:45:10.621784	2025-09-01 13:45:10.621784
21	28	2025	Casual Leave	3.00	1.00	2.00	2025-09-01 13:45:10.61461	2025-09-01 14:42:29.687397
31	14	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-01 14:43:47.078445	2025-09-01 14:43:47.078445
32	14	2025	Sick Leave	3.00	0.00	3.00	2025-09-01 14:43:47.078445	2025-09-01 14:43:47.078445
33	14	2025	Casual Leave	3.00	2.00	1.00	2025-09-01 14:43:47.078445	2025-09-01 14:43:47.084881
34	22	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-01 14:43:47.085602	2025-09-01 14:43:47.085602
35	22	2025	Sick Leave	3.00	0.00	3.00	2025-09-01 14:43:47.085602	2025-09-01 14:43:47.085602
36	22	2025	Casual Leave	3.00	1.00	2.00	2025-09-01 14:43:47.085602	2025-09-01 14:43:47.086366
37	29	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-01 20:31:57.480709	2025-09-01 20:31:57.480709
38	29	2025	Sick Leave	3.00	0.00	3.00	2025-09-01 20:31:57.480709	2025-09-01 20:31:57.480709
73	46	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-06 16:15:28.034815	2025-09-06 16:15:28.034815
39	29	2025	Casual Leave	3.00	4.00	-1.00	2025-09-01 20:31:57.480709	2025-09-01 20:41:09.483774
40	51	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-02 12:01:35.777553	2025-09-02 12:01:35.777553
41	51	2025	Sick Leave	3.00	0.00	3.00	2025-09-02 12:01:35.777553	2025-09-02 12:01:35.777553
42	51	2025	Casual Leave	3.00	1.00	2.00	2025-09-02 12:01:35.777553	2025-09-02 12:04:05.868858
43	59	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-02 14:01:54.334363	2025-09-02 14:01:54.334363
44	59	2025	Sick Leave	3.00	0.00	3.00	2025-09-02 14:01:54.334363	2025-09-02 14:01:54.334363
45	59	2025	Casual Leave	3.00	1.00	2.00	2025-09-02 14:01:54.334363	2025-09-02 14:18:31.971444
46	65	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-02 16:24:31.15047	2025-09-02 16:24:31.15047
47	65	2025	Sick Leave	3.00	0.00	3.00	2025-09-02 16:24:31.15047	2025-09-02 16:24:31.15047
48	65	2025	Casual Leave	3.00	1.00	2.00	2025-09-02 16:24:31.15047	2025-09-02 16:26:26.938377
49	67	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-02 18:00:04.725981	2025-09-02 18:00:04.725981
50	67	2025	Sick Leave	3.00	0.00	3.00	2025-09-02 18:00:04.725981	2025-09-02 18:00:04.725981
51	67	2025	Casual Leave	3.00	0.00	3.00	2025-09-02 18:00:04.725981	2025-09-02 18:00:04.725981
52	90	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-03 19:12:53.401902	2025-09-03 19:12:53.401902
53	90	2025	Sick Leave	3.00	0.00	3.00	2025-09-03 19:12:53.401902	2025-09-03 19:12:53.401902
74	46	2025	Sick Leave	3.00	0.00	3.00	2025-09-06 16:15:28.034815	2025-09-06 16:15:28.034815
55	88	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-03 19:51:15.8255	2025-09-03 19:51:15.8255
56	88	2025	Sick Leave	3.00	0.00	3.00	2025-09-03 19:51:15.8255	2025-09-03 19:51:15.8255
57	88	2025	Casual Leave	3.00	1.00	2.00	2025-09-03 19:51:15.8255	2025-09-03 20:03:58.220588
54	90	2025	Casual Leave	3.00	2.00	1.00	2025-09-03 19:12:53.401902	2025-09-03 20:04:12.622658
58	2	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-04 03:42:19.449439	2025-09-04 03:42:19.449439
59	2	2025	Sick Leave	3.00	0.00	3.00	2025-09-04 03:42:19.449439	2025-09-04 03:42:19.449439
60	2	2025	Casual Leave	3.00	1.00	2.00	2025-09-04 03:42:19.449439	2025-09-04 10:25:59.523688
61	41	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-05 07:34:42.610164	2025-09-05 07:34:42.610164
62	41	2025	Sick Leave	3.00	0.00	3.00	2025-09-05 07:34:42.610164	2025-09-05 07:34:42.610164
63	41	2025	Casual Leave	3.00	0.00	3.00	2025-09-05 07:34:42.610164	2025-09-05 07:34:42.610164
64	42	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-05 08:48:43.917992	2025-09-05 08:48:43.917992
65	42	2025	Sick Leave	3.00	0.00	3.00	2025-09-05 08:48:43.917992	2025-09-05 08:48:43.917992
66	42	2025	Casual Leave	3.00	0.00	3.00	2025-09-05 08:48:43.917992	2025-09-05 08:48:43.917992
67	43	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-05 13:46:51.351621	2025-09-05 13:46:51.351621
68	43	2025	Sick Leave	3.00	0.00	3.00	2025-09-05 13:46:51.351621	2025-09-05 13:46:51.351621
69	43	2025	Casual Leave	3.00	1.00	2.00	2025-09-05 13:46:51.351621	2025-09-05 14:05:22.713246
70	44	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-06 12:13:03.433636	2025-09-06 12:13:03.433636
71	44	2025	Sick Leave	3.00	0.00	3.00	2025-09-06 12:13:03.433636	2025-09-06 12:13:03.433636
72	44	2025	Casual Leave	3.00	0.00	3.00	2025-09-06 12:13:03.433636	2025-09-06 12:13:03.433636
75	46	2025	Casual Leave	3.00	0.00	3.00	2025-09-06 16:15:28.034815	2025-09-06 16:15:28.034815
76	48	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-06 18:31:29.922491	2025-09-06 18:31:29.922491
77	48	2025	Sick Leave	3.00	0.00	3.00	2025-09-06 18:31:29.922491	2025-09-06 18:31:29.922491
78	48	2025	Casual Leave	3.00	0.00	3.00	2025-09-06 18:31:29.922491	2025-09-06 18:31:29.922491
80	49	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-08 00:49:39.427743	2025-09-08 00:49:39.427743
81	49	2025	Sick Leave	3.00	0.00	3.00	2025-09-08 00:49:39.427743	2025-09-08 00:49:39.427743
82	49	2025	Casual Leave	3.00	0.00	3.00	2025-09-08 00:49:39.427743	2025-09-08 00:49:39.427743
85	53	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-08 12:06:23.849083	2025-09-08 12:06:23.849083
86	53	2025	Sick Leave	3.00	0.00	3.00	2025-09-08 12:06:23.849083	2025-09-08 12:06:23.849083
87	53	2025	Casual Leave	3.00	0.00	3.00	2025-09-08 12:06:23.849083	2025-09-08 12:06:23.849083
88	55	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-08 13:50:53.801845	2025-09-08 13:50:53.801845
90	55	2025	Sick Leave	3.00	0.00	3.00	2025-09-08 13:50:53.801845	2025-09-08 13:50:53.801845
91	55	2025	Casual Leave	3.00	0.00	3.00	2025-09-08 13:50:53.801845	2025-09-08 13:50:53.801845
94	57	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-09 17:35:01.298697	2025-09-09 17:35:01.298697
95	57	2025	Sick Leave	3.00	0.00	3.00	2025-09-09 17:35:01.298697	2025-09-09 17:35:01.298697
96	57	2025	Casual Leave	3.00	0.00	3.00	2025-09-09 17:35:01.298697	2025-09-09 17:35:01.298697
97	56	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-09 19:30:30.244642	2025-09-09 19:30:30.244642
99	56	2025	Sick Leave	3.00	0.00	3.00	2025-09-09 19:30:30.244642	2025-09-09 19:30:30.244642
100	56	2025	Casual Leave	3.00	0.00	3.00	2025-09-09 19:30:30.244642	2025-09-09 19:30:30.244642
103	117	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-12 19:26:25.827645	2025-09-12 19:26:25.827645
104	117	2025	Sick Leave	3.00	0.00	3.00	2025-09-12 19:26:25.827645	2025-09-12 19:26:25.827645
105	117	2025	Casual Leave	3.00	0.00	3.00	2025-09-12 19:26:25.827645	2025-09-12 19:26:25.827645
106	120	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-13 20:23:25.269203	2025-09-13 20:23:25.269203
108	120	2025	Sick Leave	3.00	0.00	3.00	2025-09-13 20:23:25.269203	2025-09-13 20:23:25.269203
109	120	2025	Casual Leave	3.00	0.00	3.00	2025-09-13 20:23:25.269203	2025-09-13 20:23:25.269203
113	122	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-14 09:42:12.024912	2025-09-14 09:42:12.024912
114	122	2025	Sick Leave	3.00	0.00	3.00	2025-09-14 09:42:12.024912	2025-09-14 09:42:12.024912
115	122	2025	Casual Leave	3.00	0.00	3.00	2025-09-14 09:42:12.024912	2025-09-14 09:42:12.024912
119	118	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-16 12:41:18.863382	2025-09-16 12:41:18.863382
120	118	2025	Sick Leave	3.00	0.00	3.00	2025-09-16 12:41:18.863382	2025-09-16 12:41:18.863382
121	118	2025	Casual Leave	3.00	0.00	3.00	2025-09-16 12:41:18.863382	2025-09-16 12:41:18.863382
124	143	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-16 15:26:45.612872	2025-09-16 15:26:45.612872
125	143	2025	Sick Leave	3.00	0.00	3.00	2025-09-16 15:26:45.612872	2025-09-16 15:26:45.612872
126	143	2025	Casual Leave	3.00	0.00	3.00	2025-09-16 15:26:45.612872	2025-09-16 15:26:45.612872
127	151	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-17 01:32:04.67053	2025-09-17 01:32:04.67053
128	151	2025	Sick Leave	3.00	0.00	3.00	2025-09-17 01:32:04.67053	2025-09-17 01:32:04.67053
129	151	2025	Casual Leave	3.00	0.00	3.00	2025-09-17 01:32:04.67053	2025-09-17 01:32:04.67053
130	152	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-17 11:12:58.029935	2025-09-17 11:12:58.029935
131	152	2025	Sick Leave	3.00	0.00	3.00	2025-09-17 11:12:58.029935	2025-09-17 11:12:58.029935
132	152	2025	Casual Leave	3.00	0.00	3.00	2025-09-17 11:12:58.029935	2025-09-17 11:12:58.029935
133	153	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-17 12:46:16.399635	2025-09-17 12:46:16.399635
134	153	2025	Sick Leave	3.00	0.00	3.00	2025-09-17 12:46:16.399635	2025-09-17 12:46:16.399635
135	153	2025	Casual Leave	3.00	0.00	3.00	2025-09-17 12:46:16.399635	2025-09-17 12:46:16.399635
136	154	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-18 12:45:02.096398	2025-09-18 12:45:02.096398
137	154	2025	Sick Leave	3.00	0.00	3.00	2025-09-18 12:45:02.096398	2025-09-18 12:45:02.096398
138	154	2025	Casual Leave	3.00	0.00	3.00	2025-09-18 12:45:02.096398	2025-09-18 12:45:02.096398
139	159	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-22 13:31:07.8027	2025-09-22 13:31:07.8027
140	159	2025	Sick Leave	3.00	0.00	3.00	2025-09-22 13:31:07.8027	2025-09-22 13:31:07.8027
141	159	2025	Casual Leave	3.00	0.00	3.00	2025-09-22 13:31:07.8027	2025-09-22 13:31:07.8027
143	166	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-22 15:49:47.753584	2025-09-22 15:49:47.753584
144	166	2025	Sick Leave	3.00	0.00	3.00	2025-09-22 15:49:47.753584	2025-09-22 15:49:47.753584
145	166	2025	Casual Leave	3.00	0.00	3.00	2025-09-22 15:49:47.753584	2025-09-22 15:49:47.753584
149	167	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-22 16:42:09.751479	2025-09-22 16:42:09.751479
150	167	2025	Sick Leave	3.00	0.00	3.00	2025-09-22 16:42:09.751479	2025-09-22 16:42:09.751479
151	167	2025	Casual Leave	3.00	0.00	3.00	2025-09-22 16:42:09.751479	2025-09-22 16:42:09.751479
154	169	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-23 11:15:38.695005	2025-09-23 11:15:38.695005
155	169	2025	Sick Leave	3.00	0.00	3.00	2025-09-23 11:15:38.695005	2025-09-23 11:15:38.695005
156	169	2025	Casual Leave	3.00	0.00	3.00	2025-09-23 11:15:38.695005	2025-09-23 11:15:38.695005
\.


--
-- TOC entry 4420 (class 0 OID 24719)
-- Dependencies: 230
-- Data for Name: leave_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.leave_types (id, type_name, description, color, created_at, updated_at, max_days, is_active) FROM stdin;
4	Maternity Leave	Leave for expecting mothers	#8B5CF6	2025-08-29 09:58:36.323483	2025-08-29 09:58:36.323483	\N	t
5	Paternity Leave	Leave for new fathers	#F59E0B	2025-08-29 09:58:36.323483	2025-08-29 09:58:36.323483	\N	t
5268	Comp Off	Compensatory off for overtime work	#84CC16	2025-08-30 17:13:50.557861	2025-08-30 17:13:50.557861	\N	t
7165	Earned/Annual Leave	Annual leave earned monthly (1.25 days/month)	#3B82F6	2025-09-01 13:38:00.565511	2025-09-01 13:45:10.597849	15	t
3	Casual Leave	Short-term leave earned monthly (0.5 days/month)	#10B981	2025-08-29 09:58:36.323483	2025-09-01 13:45:10.600081	6	t
2	Sick Leave	Medical leave earned monthly (0.5 days/month)	#ff6059	2025-08-29 09:58:36.323483	2025-09-16 13:05:40.303636	6	t
\.


--
-- TOC entry 4444 (class 0 OID 33032)
-- Dependencies: 254
-- Data for Name: manager_employee_mapping; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.manager_employee_mapping (id, manager_id, employee_id, mapping_type, is_active, created_at, updated_at) FROM stdin;
37	118	124	primary	t	2025-09-15 13:11:31.610617	2025-09-15 13:11:31.610617
45	118	153	primary	t	2025-09-17 12:43:41.24814	2025-09-17 12:43:41.24814
47	118	155	primary	t	2025-09-18 14:29:02.102058	2025-09-18 14:29:02.102058
\.


--
-- TOC entry 4414 (class 0 OID 24655)
-- Dependencies: 224
-- Data for Name: managers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.managers (id, manager_id, manager_name, email, department, designation, status, created_at, updated_at, user_id, manager_id_numeric) FROM stdin;
62	cf1487	Dori D	dori77284@gmail.com	\N	\N	active	2025-09-23 11:07:16.363835	2025-09-23 11:07:16.363835	\N	\N
63	9d7183	Riya S	stalinj4747@gmail.com	\N	\N	active	2025-09-23 11:18:10.660788	2025-09-23 11:18:10.660788	\N	\N
66	9385ae	stalin J	strawhatluff124@gmail.com	\N	\N	active	2025-09-23 11:37:33.722273	2025-09-23 11:37:33.722273	\N	\N
\.


--
-- TOC entry 4448 (class 0 OID 33156)
-- Dependencies: 258
-- Data for Name: migration_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migration_log (id, migration_name, executed_at, status, details) FROM stdin;
1	002_complete_database_setup	2025-09-07 15:35:18.925158	completed	\N
2	002_complete_database_setup	2025-09-07 15:37:09.165817	completed	\N
3	002_complete_database_setup	2025-09-09 17:28:33.165094	completed	\N
4	002_complete_database_setup	2025-09-11 13:19:28.515761	completed	\N
5	002_complete_database_setup	2025-09-11 13:19:59.978374	completed	\N
6	002_complete_database_setup	2025-09-11 13:20:21.878391	completed	\N
7	005_add_personal_email_to_employee_master	2025-09-18 13:33:37.802157	completed	\N
\.


--
-- TOC entry 4410 (class 0 OID 24614)
-- Dependencies: 220
-- Data for Name: onboarded_employees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.onboarded_employees (id, user_id, employee_id, company_email, manager_id, manager_name, assigned_by, assigned_at, status, notes, created_at, updated_at, employee_type, employee_id_numeric, manager_id_numeric) FROM stdin;
21	124	\N	rishitha.jaligam@nxzen.com	aa142d	Luthen S	\N	2025-09-15 13:09:37.104478	assigned	Assigned to manager: Luthen S	2025-09-15 13:09:37.104478	2025-09-15 13:11:31.602517	\N	\N	\N
26	118	\N	stalinnithin31@gmail.com	\N	\N	\N	2025-09-16 19:42:56.975826	pending_assignment	\N	2025-09-16 19:42:56.975826	2025-09-16 19:42:56.975826	\N	\N	\N
31	123	\N	srdaspradeep@gmail.com	\N	\N	\N	2025-09-17 12:42:53.576061	pending_assignment	\N	2025-09-17 12:42:53.576061	2025-09-17 12:42:53.576061	\N	\N	\N
32	153	\N	mahendra@nxzen.com	aa142d	Luthen S	\N	2025-09-17 12:42:56.619477	assigned	Assigned to manager: Luthen S	2025-09-17 12:42:56.619477	2025-09-17 12:43:41.245158	\N	\N	\N
34	155	\N	nithin@nxzen.com	aa142d	Luthen S	\N	2025-09-18 14:28:29.338247	pending_assignment	Assigned to manager: Luthen S	2025-09-18 14:28:29.338247	2025-09-18 18:51:51.712159	\N	\N	\N
\.


--
-- TOC entry 4450 (class 0 OID 42337)
-- Dependencies: 260
-- Data for Name: onboarding; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.onboarding (id, onboarding_quarter, employment_type, status, employee_id, employee_full_name, dob, gender, mobile_number, email, alternate_email, joining_date, month_year, reporting_manager_l1, reporting_manager_l2, bu, title, skill, level, bands, accommodation, onboarding_type, pre_onboarding_email, new_joinee_forms_filled, buddy_email_sent, update_bu_heads, current_bank_account, communication_bu_team, hr_welcome_email, new_joinee_announcement, joining_kit, internal_systems, seating_area, access_card, photo_shared_admin, attendance_added, orientation_induction, induction_feedback, bgv_consent_form, offer_appointment_letter, nda, epf, employee_verification_form, insurance_form, id_proofs, emergency_contacts, bgv_initiated, bgv_report, education_docs, employment_docs_offer_relieving, employment_docs_compensation, employment_docs_payslips, offer_fitment_email, resume, bgv, enzen_signed_docs, exit_form, bu_sign_off, it_sign_off, admin_sign_off, pnc_sign_off, assets, release_doc_sign, rel_docs, fnf, exit_docs_uploaded, pnc_remarks, created_at, updated_at, created_by, updated_by, offer_letter_doc, nda_doc, epf_doc, insurance_form_doc, id_proofs_doc, bgv_consent_form_doc, bgv_report_doc, education_docs_doc, employment_docs_doc, resume_doc, passport_doc, visa_doc, driving_license_doc, documents_uploaded_at, documents_uploaded_by, employee_id_numeric) FROM stdin;
2	\N	\N	\N	EMP007	John Doe	\N	\N	\N	john.doe@example.com	\N	2025-01-15	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	f	f	f	\N	f	f	f	\N	f	\N	f	f	f	f	\N	f	f	f	f	f	f	\N	\N	f	\N	\N	\N	\N	\N	f	\N	f	f	f	f	f	f	f	\N	f	\N	f	f	\N	2025-09-11 15:21:00.046389	2025-09-11 15:21:00.046389	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
3	\N	\N	\N	EMP008	John Doe	\N	\N	\N	john.doe@example.com	\N	2025-01-15	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	f	f	f	\N	f	f	f	\N	f	\N	f	f	f	f	\N	f	f	f	f	f	f	\N	\N	f	\N	\N	\N	\N	\N	f	\N	f	f	f	f	f	f	f	\N	f	\N	f	f	\N	2025-09-11 15:24:45.57406	2025-09-11 15:24:45.57406	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
4	\N	\N	\N	EMP009	Jane Smith	\N	\N	\N	jane.smith@example.com	\N	2025-01-15	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	f	f	f	\N	f	f	f	\N	f	\N	f	f	f	f	\N	f	f	f	f	f	f	\N	\N	f	\N	\N	\N	\N	\N	f	\N	f	f	f	f	f	f	f	\N	f	\N	f	f	\N	2025-09-11 15:29:20.554507	2025-09-11 15:29:20.554507	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
1	\N	\N	\N	EMP003	Test User	\N	\N	\N	test@example.com	\N	2025-01-15	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	f	f	f	\N	f	f	f	\N	f	\N	f	f	f	f	\N	f	f	f	f	f	f	\N	\N	f	\N	\N	\N	\N	\N	f	\N	f	f	f	f	f	f	f	\N	f	\N	f	f	\N	2025-09-11 15:17:26.399733	2025-09-11 16:55:42.299834	1	\N	document-1757589942290-546660835.pdf	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-09-11 16:55:42.299834	1	\N
5	\N	\N	\N	\N	Test User Without ID	\N	\N	\N	test.nowithid@example.com	\N	2025-01-15	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	f	f	f	\N	f	f	f	\N	f	\N	f	f	f	f	\N	f	f	f	f	f	f	\N	\N	f	\N	\N	\N	\N	\N	f	\N	f	f	f	f	f	f	f	\N	f	\N	f	f	\N	2025-09-11 17:02:23.719943	2025-09-11 17:02:23.719943	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
6	\N	\N	\N	EMP999	Test User With ID	\N	\N	\N	test.withid@example.com	\N	2025-01-15	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	f	f	f	\N	f	f	f	\N	f	\N	f	f	f	f	\N	f	f	f	f	f	f	\N	\N	f	\N	\N	\N	\N	\N	f	\N	f	f	f	f	f	f	f	\N	f	\N	f	f	\N	2025-09-11 17:02:34.591729	2025-09-11 17:02:34.591729	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- TOC entry 4456 (class 0 OID 50187)
-- Dependencies: 266
-- Data for Name: pnc_monitoring_breakdowns; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pnc_monitoring_breakdowns (id, report_id, breakdown_type, category_name, category_value, count, percentage, created_at) FROM stdin;
\.


--
-- TOC entry 4454 (class 0 OID 50157)
-- Dependencies: 264
-- Data for Name: pnc_monitoring_reports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pnc_monitoring_reports (id, report_month, report_year, report_month_number, total_headcount, total_contractors, total_leavers, future_joiners, total_vacancies, average_age, average_tenure, disability_percentage, attrition_percentage, report_data, generated_at, generated_by, is_active) FROM stdin;
\.


--
-- TOC entry 4462 (class 0 OID 50607)
-- Dependencies: 272
-- Data for Name: recruitment_requisitions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recruitment_requisitions (id, requisition_id, job_title, department, location, employment_type, status, priority, min_experience, max_experience, required_skills, preferred_skills, posted_date, closing_date, filled_date, hiring_manager_id, assigned_recruiter_id, created_at, updated_at, created_by) FROM stdin;
1	REQ-2025-001	Senior Software Engineer	Engineering	\N	Full-Time	Open	High	0	\N	\N	\N	2025-09-16	\N	\N	\N	\N	2025-09-16 12:46:23.473865	2025-09-16 12:46:23.473865	\N
2	REQ-2025-002	HR Business Partner	Human Resources	\N	Full-Time	Open	Medium	0	\N	\N	\N	2025-09-16	\N	\N	\N	\N	2025-09-16 12:46:23.473865	2025-09-16 12:46:23.473865	\N
3	REQ-2025-003	Marketing Manager	Marketing	\N	Full-Time	Open	Medium	0	\N	\N	\N	2025-09-16	\N	\N	\N	\N	2025-09-16 12:46:23.473865	2025-09-16 12:46:23.473865	\N
4	REQ-2025-004	DevOps Engineer	Engineering	\N	Full-Time	Closed	High	0	\N	\N	\N	2025-09-16	\N	\N	\N	\N	2025-09-16 12:46:23.473865	2025-09-16 12:46:23.473865	\N
5	REQ-2025-005	Financial Analyst	Finance	\N	Full-Time	Open	Low	0	\N	\N	\N	2025-09-16	\N	\N	\N	\N	2025-09-16 12:46:23.473865	2025-09-16 12:46:23.473865	\N
\.


--
-- TOC entry 4472 (class 0 OID 51111)
-- Dependencies: 284
-- Data for Name: relations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.relations (id, name, is_active, created_at) FROM stdin;
1	Father	t	2025-09-18 19:53:24.564955
2	Mother	t	2025-09-18 19:53:24.564955
3	Spouse	t	2025-09-18 19:53:24.564955
4	Sibling	t	2025-09-18 19:53:24.564955
5	Child	t	2025-09-18 19:53:24.564955
6	Friend	t	2025-09-18 19:53:24.564955
7	Other	t	2025-09-18 19:53:24.564955
\.


--
-- TOC entry 4424 (class 0 OID 24782)
-- Dependencies: 234
-- Data for Name: system_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.system_settings (id, total_annual_leaves, allow_half_day, approval_workflow, created_at, updated_at) FROM stdin;
1	15	t	manager_then_hr	2025-08-29 20:09:54.234378	2025-09-09 19:24:34.522537
\.


--
-- TOC entry 4408 (class 0 OID 24578)
-- Dependencies: 218
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, password, role, temp_password, first_name, last_name, phone, address, emergency_contact_name, emergency_contact_phone, emergency_contact_relationship, created_at, updated_at, emergency_contact_name2, emergency_contact_phone2, emergency_contact_relationship2, is_first_login) FROM stdin;
118	stalinnithin31@gmail.com	$2a$10$C8zDkRkTRBjIgr68ajjEGuSl2DH7ClYyWRRJKYiiIMqenCsEm3CIa	manager	\N	Luthen	S	\N	\N	\N	\N	\N	2025-09-12 18:34:28.771547	2025-09-16 19:42:57.000141	\N	\N	\N	t
137	testdebug@example.com		employee	x6kY6Py1	Test	User Debug	\N	\N	\N	\N	\N	2025-09-16 14:30:03.332584	2025-09-16 14:30:03.332584	\N	\N	\N	t
153	mahendra@nxzen.com	$2a$10$lAHWYj/oWt8aiz0QDNmR6.22FQXIXIcOKRq4uRwKkS8bfv6tyfoMe	employee	\N	Mahendra	Teja	\N	\N	\N	\N	\N	2025-09-17 12:37:55.46162	2025-09-17 12:43:41.230483	\N	\N	\N	t
1	hr@nxzen.com	$2a$10$Pdb6iKx2lQ2hbI31N.XSWeQgpjAQ8oaS3YYWmphKo7DYNcC9SLSTe	hr	\N	HR	Manager	\N	\N	\N	\N	\N	2025-09-04 03:20:17.624157	2025-09-18 14:11:25.447886	\N	\N	\N	f
155	nithin@nxzen.com	$2a$10$oU5P0Yz2AHqwBRCtxXaubOv7vxa2yrxt.trRZw5ZrRo4UIBVCy6LO	employee	\N	Nithin	 J	\N	\N	\N	\N	\N	2025-09-18 13:52:17.311746	2025-09-18 14:29:02.086173	\N	\N	\N	t
123	srdaspradeep@gmail.com	$2a$10$v6/.LbUJYiqObrT2tItknOCB9Q.8PtmNRUISA1SdTY0NntETxcQqi	employee	\N	Pradeep	test 1	\N	\N	\N	\N	\N	2025-09-15 12:41:56.307826	2025-09-15 12:43:25.029065	\N	\N	\N	t
124	rishitha.jaligam@nxzen.com	$2a$10$/sUsNoiMTzkcJnvnzby5fOXDDJFTErmqBDpzzUrGjfZ2/FkQc7eXa	employee	\N	Rishitha	Jaligam	\N	\N	\N	\N	\N	2025-09-15 12:58:09.742393	2025-09-15 13:11:31.593591	\N	\N	\N	t
135	test@example.com		employee	8aWnvmQT	Test	User	\N	\N	\N	\N	\N	2025-09-16 14:27:19.362498	2025-09-16 14:27:19.362498	\N	\N	\N	t
136	testnew@example.com		employee	k4aISpqh	Test	User New	\N	\N	\N	\N	\N	2025-09-16 14:28:01.88605	2025-09-16 14:28:01.88605	\N	\N	\N	t
\.


--
-- TOC entry 4575 (class 0 OID 0)
-- Dependencies: 273
-- Name: adp_payroll_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adp_payroll_id_seq', 1, true);


--
-- TOC entry 4576 (class 0 OID 0)
-- Dependencies: 225
-- Name: attendance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attendance_id_seq', 144, true);


--
-- TOC entry 4577 (class 0 OID 0)
-- Dependencies: 255
-- Name: attendance_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attendance_settings_id_seq', 6157, true);


--
-- TOC entry 4578 (class 0 OID 0)
-- Dependencies: 239
-- Name: comp_off_balances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comp_off_balances_id_seq', 5, true);


--
-- TOC entry 4579 (class 0 OID 0)
-- Dependencies: 241
-- Name: company_emails_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.company_emails_id_seq', 235, true);


--
-- TOC entry 4580 (class 0 OID 0)
-- Dependencies: 235
-- Name: departments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.departments_id_seq', 4800, true);


--
-- TOC entry 4581 (class 0 OID 0)
-- Dependencies: 247
-- Name: document_collection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.document_collection_id_seq', 592, true);


--
-- TOC entry 4582 (class 0 OID 0)
-- Dependencies: 267
-- Name: document_reminder_mails_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.document_reminder_mails_id_seq', 19, true);


--
-- TOC entry 4583 (class 0 OID 0)
-- Dependencies: 249
-- Name: document_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.document_templates_id_seq', 25156, true);


--
-- TOC entry 4584 (class 0 OID 0)
-- Dependencies: 279
-- Name: documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.documents_id_seq', 1, false);


--
-- TOC entry 4585 (class 0 OID 0)
-- Dependencies: 237
-- Name: employee_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_documents_id_seq', 143, true);


--
-- TOC entry 4586 (class 0 OID 0)
-- Dependencies: 261
-- Name: employee_forms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_forms_id_seq', 59, true);


--
-- TOC entry 4587 (class 0 OID 0)
-- Dependencies: 221
-- Name: employee_master_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_master_id_seq', 161, true);


--
-- TOC entry 4588 (class 0 OID 0)
-- Dependencies: 269
-- Name: employees_combined_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employees_combined_id_seq', 10, true);


--
-- TOC entry 4589 (class 0 OID 0)
-- Dependencies: 245
-- Name: expense_attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.expense_attachments_id_seq', 1, false);


--
-- TOC entry 4590 (class 0 OID 0)
-- Dependencies: 275
-- Name: expense_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.expense_categories_id_seq', 12, true);


--
-- TOC entry 4591 (class 0 OID 0)
-- Dependencies: 277
-- Name: expense_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.expense_requests_id_seq', 17, true);


--
-- TOC entry 4592 (class 0 OID 0)
-- Dependencies: 243
-- Name: expenses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.expenses_id_seq', 45, true);


--
-- TOC entry 4593 (class 0 OID 0)
-- Dependencies: 231
-- Name: leave_balances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.leave_balances_id_seq', 33, true);


--
-- TOC entry 4594 (class 0 OID 0)
-- Dependencies: 227
-- Name: leave_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.leave_requests_id_seq', 35, true);


--
-- TOC entry 4595 (class 0 OID 0)
-- Dependencies: 251
-- Name: leave_type_balances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.leave_type_balances_id_seq', 156, true);


--
-- TOC entry 4596 (class 0 OID 0)
-- Dependencies: 229
-- Name: leave_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.leave_types_id_seq', 14923, true);


--
-- TOC entry 4597 (class 0 OID 0)
-- Dependencies: 253
-- Name: manager_employee_mapping_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.manager_employee_mapping_id_seq', 58, true);


--
-- TOC entry 4598 (class 0 OID 0)
-- Dependencies: 223
-- Name: managers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.managers_id_seq', 66, true);


--
-- TOC entry 4599 (class 0 OID 0)
-- Dependencies: 257
-- Name: migration_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migration_log_id_seq', 7, true);


--
-- TOC entry 4600 (class 0 OID 0)
-- Dependencies: 219
-- Name: onboarded_employees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.onboarded_employees_id_seq', 46, true);


--
-- TOC entry 4601 (class 0 OID 0)
-- Dependencies: 259
-- Name: onboarding_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.onboarding_id_seq', 12, true);


--
-- TOC entry 4602 (class 0 OID 0)
-- Dependencies: 265
-- Name: pnc_monitoring_breakdowns_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pnc_monitoring_breakdowns_id_seq', 1, false);


--
-- TOC entry 4603 (class 0 OID 0)
-- Dependencies: 263
-- Name: pnc_monitoring_reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pnc_monitoring_reports_id_seq', 26, true);


--
-- TOC entry 4604 (class 0 OID 0)
-- Dependencies: 271
-- Name: recruitment_requisitions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recruitment_requisitions_id_seq', 10, true);


--
-- TOC entry 4605 (class 0 OID 0)
-- Dependencies: 283
-- Name: relations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.relations_id_seq', 7, true);


--
-- TOC entry 4606 (class 0 OID 0)
-- Dependencies: 233
-- Name: system_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.system_settings_id_seq', 1, true);


--
-- TOC entry 4607 (class 0 OID 0)
-- Dependencies: 217
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 176, true);


-- Completed on 2025-09-23 11:49:03 IST

--
-- PostgreSQL database dump complete
--

