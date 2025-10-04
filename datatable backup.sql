--
-- PostgreSQL database dump
--

-- Dumped from database version 15.14 (Homebrew)
-- Dumped by pg_dump version 17.5

-- Started on 2025-10-04 01:22:30 IST

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
-- TOC entry 4512 (class 0 OID 18509)
-- Dependencies: 214
-- Data for Name: adp_payroll; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.adp_payroll (id, employee_id, name_prefix, employee_full_name, given_or_first_name, middle_name, last_name, joining_date, payroll_starting_month, dob, aadhar, name_as_per_aadhar, designation_description, email, alternate_email, pan, name_as_per_pan, gender, department_description, work_location, labour_state_description, lwf_designation, lwf_relationship, lwf_id, professional_tax_group_description, pf_computational_group, mobile_number, phone_number1, phone_number2, address1, address2, address3, city, state, pincode, country, nationality, iw_nationality, iw_city, iw_country, coc_issuing_authority, coc_issue_date, coc_from_date, coc_upto_date, bank_name, name_as_per_bank, account_no, bank_ifsc_code, payment_mode, pf_account_no, esi_account_no, esi_above_wage_limit, uan, branch_description, enrollment_id, manager_employee_id, tax_regime, father_name, mother_name, spouse_name, marital_status, number_of_children, disability_status, type_of_disability, employment_type, grade_description, cadre_description, payment_description, attendance_description, workplace_description, band, level, work_cost_center, custom_group_1, custom_group_2, custom_group_3, custom_group_4, custom_group_5, passport_number, passport_issue_date, passport_valid_upto, passport_issued_country, visa_issuing_authority, visa_from_date, visa_upto_date, already_member_in_pf, already_member_in_pension, withdrawn_pf_and_pension, international_worker_status, relationship_for_pf, qualification, driving_licence_number, driving_licence_valid_date, pran_number, rehire, old_employee_id, is_non_payroll_employee, category_name, custom_master_name, custom_master_name2, custom_master_name3, ot_eligibility, auto_shift_eligibility, mobile_user, web_punch, attendance_exception_eligibility, attendance_exception_type, is_draft, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4514 (class 0 OID 18534)
-- Dependencies: 216
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attendance (id, employee_id, date, status, reason, clock_in_time, clock_out_time, created_at, updated_at, hours) FROM stdin;
130	153	2025-09-16	absent	\N	\N	\N	2025-09-17 12:45:42.139498	2025-09-17 12:45:42.139498	\N
132	153	2025-09-18	Work From Home	\N	\N	\N	2025-09-17 12:45:46.626166	2025-09-17 12:45:49.041148	4
133	153	2025-09-19	Half Day	\N	\N	\N	2025-09-17 12:45:51.525187	2025-09-17 12:45:53.640762	8
129	153	2025-09-15	present	\N	\N	\N	2025-09-17 12:45:39.977688	2025-09-17 12:45:57.263165	8
131	153	2025-09-17	present	\N	\N	\N	2025-09-17 12:45:44.254758	2025-09-17 12:46:01.80758	8
8	1	2025-09-04	present	\N	\N	\N	2025-09-04 14:20:33.446579	2025-09-04 14:22:23.51348	\N
16	1	2025-09-01	present		\N	\N	2025-09-04 16:46:40.180855	2025-09-04 16:46:40.180855	\N
17	1	2025-09-02	leave		\N	\N	2025-09-04 16:47:31.343174	2025-09-04 16:47:31.343174	\N
18	1	2025-09-03	absent		\N	\N	2025-09-04 16:47:50.049928	2025-09-04 16:47:50.049928	\N
103	118	2025-09-12	present	\N	19:48:00	\N	2025-09-12 19:48:14.696158	2025-09-12 19:48:14.696158	8
111	124	2025-09-15	present	\N	\N	\N	2025-09-15 13:17:15.228358	2025-09-15 13:17:15.228358	\N
113	118	2025-09-15	present	\N	12:40:00	\N	2025-09-16 12:40:59.923393	2025-09-16 12:40:59.923393	8
114	118	2025-09-16	present	\N	12:40:00	\N	2025-09-16 12:41:01.623753	2025-09-16 12:41:01.623753	8
\.


--
-- TOC entry 4516 (class 0 OID 18543)
-- Dependencies: 218
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
-- TOC entry 4520 (class 0 OID 18578)
-- Dependencies: 223
-- Data for Name: comp_off_balances; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comp_off_balances (id, employee_id, year, total_earned, comp_off_taken, comp_off_remaining, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4522 (class 0 OID 18587)
-- Dependencies: 225
-- Data for Name: company_emails; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.company_emails (id, user_id, manager_id, company_email, is_primary, is_active, created_at, updated_at) FROM stdin;
195	124	\N	rishitha.jaligam@nxzen.com	t	t	2025-09-15 13:35:06.249934	2025-09-15 13:35:06.249934
111	1	\N	hr@nxzen.com	t	t	2025-09-04 13:32:47.614712	2025-09-04 13:32:47.614712
219	153	\N	mahendra@nxzen.com	t	t	2025-09-17 16:59:27.968935	2025-09-17 16:59:27.968935
190	118	\N	stalinnithin31@nxzen.com	t	t	2025-09-12 18:41:36.672494	2025-09-12 18:41:36.672494
238	\N	cf1487	dori.d@nxzen.com	t	t	2025-09-25 16:12:44.291956	2025-09-25 16:12:44.291956
239	\N	9d7183	riya.s@nxzen.com	t	t	2025-09-25 16:12:44.292743	2025-09-25 16:12:44.292743
240	\N	9385ae	stalin.j@nxzen.com	t	t	2025-09-25 16:12:44.293827	2025-09-25 16:12:44.293827
250	194	\N	dori7728@nxzen.com	t	t	2025-09-26 00:33:19.770923	2025-09-26 00:33:19.770923
\.


--
-- TOC entry 4524 (class 0 OID 18596)
-- Dependencies: 227
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
-- TOC entry 4526 (class 0 OID 18605)
-- Dependencies: 229
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
308	118	Luthen S	118	N/A	2025-09-16	2025-10-16	Form 16 / Form 12B / Taxable Income Statement	form16	Not Uploaded	Document required for onboarding	\N	\N	\N	2025-09-16 19:42:56.985943	2025-09-16 19:42:56.985943	0	\N	\N
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
-- TOC entry 4528 (class 0 OID 18617)
-- Dependencies: 231
-- Data for Name: document_reminder_mails; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.document_reminder_mails (id, employee_id, employee_email, employee_name, sent_by_hr_id, sent_by_hr_name, sent_at, document_upload_link, status, created_at) FROM stdin;
\.


--
-- TOC entry 4530 (class 0 OID 18626)
-- Dependencies: 233
-- Data for Name: document_templates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.document_templates (id, document_name, document_type, description, is_active, created_at, updated_at, category, is_required, allow_multiple) FROM stdin;
9	Passport Size Photographs	Required	Recent passport size photographs	t	2025-09-01 08:21:28.000725	2025-09-01 08:21:28.000725	\N	f	f
1	Updated Resume	resume	Current resume with latest experience and skills	t	2025-09-01 08:21:28.000725	2025-09-02 23:19:19.796299	employment	f	f
2	Offer & Appointment Letter	offer_letter	Official offer letter and appointment confirmation	t	2025-09-01 08:21:28.000725	2025-09-02 23:19:19.804258	employment	f	f
3	Latest Compensation Letter	compensation_letter	Most recent salary and compensation details	t	2025-09-01 08:21:28.000725	2025-09-02 23:19:19.804985	employment	f	f
4	Experience & Relieving Letter	experience_letter	Previous employment experience and relieving letter	t	2025-09-01 08:21:28.000725	2025-09-02 23:19:19.805343	employment	f	f
5	Latest 3 Months Pay Slips	payslip	Pay slips from the last 3 months of previous employment	t	2025-09-01 08:21:28.000725	2025-09-02 23:19:19.805684	employment	f	t
6	Form 16 / Form 12B / Taxable Income Statement	form16	Tax-related documents for income verification	t	2025-09-01 08:21:28.000725	2025-09-02 23:19:19.806183	employment	f	f
2383	SSC Certificate (10th)	ssc_certificate	Secondary School Certificate for 10th standard	t	2025-09-01 19:12:26.889746	2025-09-02 23:19:19.806572	education	f	f
9340	Cancelled Checkbook	cancelled_checkbook	Cancelled checkbook for bank account verification	t	2025-09-10 15:58:29.247488	2025-09-10 15:58:29.247488	employment	f	f
2388	Graduation Original/Provisional Certificate	graduation_certificate	Graduation original or provisional certificate	t	2025-09-01 19:12:26.889746	2025-09-02 23:19:19.808357	education	f	f
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
\.


--
-- TOC entry 4532 (class 0 OID 18638)
-- Dependencies: 235
-- Data for Name: documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.documents (id, employee_id, document_type, file_name, file_path, file_size, mime_type, status, uploaded_by, reviewed_by, reviewed_at, review_notes, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4534 (class 0 OID 18653)
-- Dependencies: 238
-- Data for Name: employee_documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_documents (id, employee_id, document_type, document_category, file_name, file_url, file_size, mime_type, is_required, uploaded_at, updated_at, resend_count, last_resend_date, status) FROM stdin;
79	124	graduation_certificate	education	Screenshot 2025-09-10 at 4.31.14â¯PM.png	uploads/documents/documents-1757921890833-41908495.png	36072	image/png	f	2025-09-15 13:08:10.838788	2025-09-15 13:08:10.838788	0	\N	pending
80	124	aadhaar	identity	Screenshot 2025-09-10 at 4.31.14â¯PM.png	uploads/documents/documents-1757921896026-885841530.png	36072	image/png	f	2025-09-15 13:08:16.027882	2025-09-15 13:08:16.027882	0	\N	pending
81	124	pan	identity	Screenshot 2025-09-09 at 7.10.41â¯PM.png	uploads/documents/documents-1757921899416-578800975.png	878933	image/png	f	2025-09-15 13:08:19.420598	2025-09-15 13:08:19.420598	0	\N	pending
105	153	graduation_certificate	education	1-31c767cf-bed8-47f6-8d9f-ebc55c4a76ef-1.pdf	uploads/documents/documents-1758093101071-465273870.pdf	120848	application/pdf	f	2025-09-17 12:41:41.078863	2025-09-17 12:41:41.078863	0	\N	pending
106	153	aadhaar	identity	1-a0a2d4c7-0bc6-4c06-900e-0db6f449656e.pdf	uploads/documents/documents-1758093107976-383873921.pdf	120461	application/pdf	f	2025-09-17 12:41:47.979334	2025-09-17 12:41:47.979334	0	\N	pending
107	153	pan	identity	1-230ed728-bd80-4ed7-ab27-a68b0e5a1cb3.pdf	uploads/documents/documents-1758093114108-818766209.pdf	120795	application/pdf	f	2025-09-17 12:41:54.115941	2025-09-17 12:41:54.115941	0	\N	pending
\.


--
-- TOC entry 4536 (class 0 OID 18665)
-- Dependencies: 240
-- Data for Name: employee_forms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_forms (id, employee_id, type, form_data, files, status, submitted_at, updated_at, reviewed_by, reviewed_at, review_notes, draft_data, documents_uploaded, assigned_manager, manager2_name, manager3_name, employee_type) FROM stdin;
7	124	Intern	{"doj": "2025-09-16", "name": "Jaliga", "email": "jaligamrishitha@gmail.com", "phone": "6567567576", "address": "45 Oceanview Drive, Miami, FL 33101", "education": "MBA, University of Miami, 2020", "experience": "", "submittedAt": "2025-09-15T07:37:52.460Z", "emergencyContact": {"name": "Carlos Ramirez", "phone": "3055554567", "relationship": "Brother"}, "emergencyContact2": {"name": "Maria Ramirez", "phone": "5765765765", "relationship": "Father"}}	{}	approved	2025-09-15 13:09:37.102993	2025-09-15 13:09:37.102993	\N	\N	\N	\N	\N	\N	\N	\N	\N
36	153	Full-Time	{"doj": "", "name": "Mahendra Teja", "email": "mahendratejak8@gmail.com", "phone": "9876543456", "address": "RTFCgvhbj", "education": "RTDfygubh", "experience": "", "submittedAt": "2025-09-17T07:11:05.092Z", "emergencyContact": {"name": "rtfyvgbjh", "phone": "9876544567", "relationship": "fghj"}, "emergencyContact2": {"name": "xdfgvbhnj", "phone": "4567898745", "relationship": "erfghj"}}	{}	approved	2025-09-17 12:42:56.612817	2025-09-17 12:42:56.612817	\N	\N	\N	\N	\N	\N	\N	\N	\N
77	197	Manager	\N	\N	pending	\N	2025-09-26 00:38:10.849765	\N	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- TOC entry 4518 (class 0 OID 18551)
-- Dependencies: 220
-- Data for Name: employee_master; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_master (id, employee_id, employee_name, company_email, manager_id, manager_name, type, role, doj, status, department, designation, salary_band, location, created_at, updated_at, department_id, manager2_id, manager2_name, manager3_id, manager3_name, employee_id_numeric, manager_id_numeric, manager2_id_numeric, manager3_id_numeric, email) FROM stdin;
45	aa142d	Luthen S	stalinnithin31@gmail.com	\N	\N	Manager	\N	2025-09-12	active	\N	\N	\N	\N	2025-09-12 18:34:28.771547	2025-09-12 18:34:28.771547	\N	\N	\N	\N	\N	\N	\N	\N	\N	stalinnithin31@gmail.com
51	692539	Risitha	rishitha.jaligam@nxzen.com	aa142d	Luthen S	Intern	\N	2025-09-16	active	\N	\N	\N	\N	2025-09-15 13:11:31.605265	2025-09-15 13:11:31.605265	\N	\N	\N	\N	\N	\N	\N	\N	\N	jaligamrishitha@gmail.com
141	256409	Mahendra Teja	mahendra@nxzen.com	aa142d	Luthen S	Full-Time	\N	2025-09-17	active	\N	\N	\N	\N	2025-09-17 12:43:41.24581	2025-09-17 12:43:41.24581	\N	\N	\N	\N	\N	\N	\N	\N	\N	mahendratejak8@gmail.com
180	254014	Dori D	dori77284@gmail.com	\N	\N	Manager	\N	2025-09-25	active	\N	\N	\N	\N	2025-09-26 00:38:10.855177	2025-09-26 00:38:10.855177	\N	\N	\N	\N	\N	\N	\N	\N	\N	dori77284@gmail.com
\.


--
-- TOC entry 4539 (class 0 OID 18674)
-- Dependencies: 243
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
-- TOC entry 4541 (class 0 OID 18700)
-- Dependencies: 245
-- Data for Name: expense_attachments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.expense_attachments (id, expense_id, file_name, file_url, file_size, mime_type, uploaded_at) FROM stdin;
\.


--
-- TOC entry 4543 (class 0 OID 18707)
-- Dependencies: 247
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
-- TOC entry 4545 (class 0 OID 18716)
-- Dependencies: 249
-- Data for Name: expense_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.expense_requests (id, employee_id, category_id, amount, description, expense_date, receipt_url, status, approved_by, approved_at, approval_notes, created_at, updated_at) FROM stdin;
1	1	1	1500.00	Client meeting travel	2025-09-15	\N	approved	1	2025-09-17 11:20:55.691039	\N	2025-09-17 11:20:55.691039	2025-09-17 11:20:55.691039
2	1	2	800.00	Business lunch	2025-09-14	\N	approved	1	2025-09-17 11:20:55.691039	\N	2025-09-17 11:20:55.691039	2025-09-17 11:20:55.691039
3	1	3	2500.00	Office supplies	2025-09-13	\N	approved	1	2025-09-17 11:20:55.691039	\N	2025-09-17 11:20:55.691039	2025-09-17 11:20:55.691039
4	1	4	5000.00	Training course	2025-09-12	\N	approved	1	2025-09-17 11:20:55.691039	\N	2025-09-17 11:20:55.691039	2025-09-17 11:20:55.691039
5	1	5	1200.00	Internet bill	2025-09-11	\N	approved	1	2025-09-17 11:20:55.691039	\N	2025-09-17 11:20:55.691039	2025-09-17 11:20:55.691039
6	1	1	2000.00	Conference travel	2025-08-20	\N	approved	1	2025-09-17 11:21:14.955846	\N	2025-09-17 11:21:14.955846	2025-09-17 11:21:14.955846
7	1	2	1200.00	Team dinner	2025-08-15	\N	approved	1	2025-09-17 11:21:14.955846	\N	2025-09-17 11:21:14.955846	2025-09-17 11:21:14.955846
8	1	3	1800.00	Software license	2025-08-10	\N	approved	1	2025-09-17 11:21:14.955846	\N	2025-09-17 11:21:14.955846	2025-09-17 11:21:14.955846
9	1	4	3000.00	Certification exam	2025-07-25	\N	approved	1	2025-09-17 11:21:14.955846	\N	2025-09-17 11:21:14.955846	2025-09-17 11:21:14.955846
10	1	5	900.00	Phone bill	2025-07-20	\N	approved	1	2025-09-17 11:21:14.955846	\N	2025-09-17 11:21:14.955846	2025-09-17 11:21:14.955846
11	1	6	1500.00	Miscellaneous	2025-07-15	\N	approved	1	2025-09-17 11:21:14.955846	\N	2025-09-17 11:21:14.955846	2025-09-17 11:21:14.955846
\.


--
-- TOC entry 4547 (class 0 OID 18726)
-- Dependencies: 251
-- Data for Name: expenses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.expenses (id, series, employee_id, employee_name, expense_category, expense_type, other_category, amount, currency, description, attachment_url, attachment_name, expense_date, project_reference, payment_mode, tax_included, total_reimbursable, status, manager1_id, manager1_name, manager1_status, manager1_approved_at, manager1_approval_notes, manager2_id, manager2_name, manager2_status, manager2_approved_at, manager2_approval_notes, manager3_id, manager3_name, manager3_status, manager3_approved_at, manager3_approval_notes, hr_id, hr_name, hr_approved_at, hr_approval_notes, approval_token, created_at, updated_at, client_code) FROM stdin;
\.


--
-- TOC entry 4549 (class 0 OID 18741)
-- Dependencies: 253
-- Data for Name: leave_balances; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.leave_balances (id, employee_id, year, total_allocated, leaves_taken, leaves_remaining, created_at, updated_at) FROM stdin;
2	1	2025	15	0	15	2025-09-04 10:56:56.180234	2025-09-09 19:24:33.225864
23	118	2025	15	0	15	2025-09-16 12:41:18.848259	2025-09-16 12:41:18.848259
27	153	2025	15	0	15	2025-09-17 12:46:16.39094	2025-09-17 12:46:16.39094
\.


--
-- TOC entry 4551 (class 0 OID 18750)
-- Dependencies: 255
-- Data for Name: leave_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.leave_requests (id, series, employee_id, employee_name, leave_type, leave_balance_before, from_date, to_date, half_day, total_leave_days, reason, status, manager_approved_at, manager_approval_notes, hr_id, hr_name, hr_approved_at, hr_approval_notes, approval_token, created_at, updated_at, manager1_id, manager1_name, manager1_status, manager2_id, manager2_name, manager2_status, manager3_id, manager3_name, manager3_status, approved_by, approved_at, approval_notes, role) FROM stdin;
6	LR-MF561R38-781XI	1	HR Manager	Sick Leave	15.0	2024-02-01	2024-02-03	f	3.0	Not feeling well	rejected	\N	\N	1	HR Manager	2025-09-08 12:59:57.772043		d8aa64375ecc15a48795da7771405446b3d4a6a2d270400eb9e6be4d670b60b6	2025-09-04 14:20:35.498759	2025-09-08 12:59:57.772043	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	employee
7	LR-MF564406-E5SG9	1	HR Manager	Sick Leave	15.0	2024-02-01	2024-02-03	f	3.0	Not feeling well	rejected	\N	\N	1	HR Manager	2025-09-12 19:52:54.598212		459e028268d3c57f1b9c5f5b9cafc1f94bae23c89768313bca7066fafcbc429c	2025-09-04 14:22:25.546671	2025-09-12 19:52:54.598212	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	employee
\.


--
-- TOC entry 4553 (class 0 OID 18765)
-- Dependencies: 257
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
158	178	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-25 22:50:16.93682	2025-09-25 22:50:16.93682
159	178	2025	Sick Leave	3.00	0.00	3.00	2025-09-25 22:50:16.93682	2025-09-25 22:50:16.93682
160	178	2025	Casual Leave	3.00	0.00	3.00	2025-09-25 22:50:16.93682	2025-09-25 22:50:16.93682
163	195	2025	Earned/Annual Leave	7.50	0.00	7.50	2025-09-26 00:21:28.910765	2025-09-26 00:21:28.910765
165	195	2025	Sick Leave	3.00	0.00	3.00	2025-09-26 00:21:28.910765	2025-09-26 00:21:28.910765
166	195	2025	Casual Leave	3.00	0.00	3.00	2025-09-26 00:21:28.910765	2025-09-26 00:21:28.910765
\.


--
-- TOC entry 4555 (class 0 OID 18774)
-- Dependencies: 259
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
-- TOC entry 4557 (class 0 OID 18784)
-- Dependencies: 261
-- Data for Name: manager_employee_mapping; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.manager_employee_mapping (id, manager_id, employee_id, mapping_type, is_active, created_at, updated_at) FROM stdin;
37	118	124	primary	t	2025-09-15 13:11:31.610617	2025-09-15 13:11:31.610617
45	118	153	primary	t	2025-09-17 12:43:41.24814	2025-09-17 12:43:41.24814
\.


--
-- TOC entry 4559 (class 0 OID 18792)
-- Dependencies: 263
-- Data for Name: managers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.managers (id, manager_id, manager_name, email, department, designation, status, created_at, updated_at, user_id, manager_id_numeric) FROM stdin;
62	cf1487	Dori D	dori77284@gmail.com	\N	\N	active	2025-09-23 11:07:16.363835	2025-09-23 11:07:16.363835	\N	\N
63	9d7183	Riya S	stalinj4747@gmail.com	\N	\N	active	2025-09-23 11:18:10.660788	2025-09-23 11:18:10.660788	\N	\N
66	9385ae	stalin J	strawhatluff124@gmail.com	\N	\N	active	2025-09-23 11:37:33.722273	2025-09-23 11:37:33.722273	\N	\N
\.


--
-- TOC entry 4561 (class 0 OID 18802)
-- Dependencies: 265
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
-- TOC entry 4563 (class 0 OID 18809)
-- Dependencies: 267
-- Data for Name: onboarded_employees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.onboarded_employees (id, user_id, employee_id, company_email, manager_id, manager_name, assigned_by, assigned_at, status, notes, created_at, updated_at, employee_type, employee_id_numeric, manager_id_numeric) FROM stdin;
21	124	\N	rishitha.jaligam@nxzen.com	aa142d	Luthen S	\N	2025-09-15 13:09:37.104478	assigned	Assigned to manager: Luthen S	2025-09-15 13:09:37.104478	2025-09-15 13:11:31.602517	\N	\N	\N
26	118	\N	stalinnithin31@gmail.com	\N	\N	\N	2025-09-16 19:42:56.975826	pending_assignment	\N	2025-09-16 19:42:56.975826	2025-09-16 19:42:56.975826	\N	\N	\N
32	153	\N	mahendra@nxzen.com	aa142d	Luthen S	\N	2025-09-17 12:42:56.619477	assigned	Assigned to manager: Luthen S	2025-09-17 12:42:56.619477	2025-09-17 12:43:41.245158	\N	\N	\N
\.


--
-- TOC entry 4565 (class 0 OID 18821)
-- Dependencies: 269
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
-- TOC entry 4567 (class 0 OID 18860)
-- Dependencies: 271
-- Data for Name: pnc_monitoring_breakdowns; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pnc_monitoring_breakdowns (id, report_id, breakdown_type, category_name, category_value, count, percentage, created_at) FROM stdin;
\.


--
-- TOC entry 4569 (class 0 OID 18870)
-- Dependencies: 273
-- Data for Name: pnc_monitoring_reports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pnc_monitoring_reports (id, report_month, report_year, report_month_number, total_headcount, total_contractors, total_leavers, future_joiners, total_vacancies, average_age, average_tenure, disability_percentage, attrition_percentage, report_data, generated_at, generated_by, is_active) FROM stdin;
29	2025-10	2025	10	0	0	0	0	0	0.00	0.00	0.00	0.00	{"month": "2025-10", "gender": [{"name": "Male", "count": 0}, {"name": "Female", "count": 0}, {"name": "Prefer not to say", "count": 0}], "period": {"endOfMonth": "2025-10-31", "startOfMonth": "2025-10-01", "lastDayOfMonth": 31}, "tenure": {"groups": [{"name": "Less than 12 months", "count": 4}, {"name": "1-3 Years", "count": 0}, {"name": "4-6 Years", "count": 0}, {"name": "7-10 Years", "count": 0}, {"name": "11+ years", "count": 0}], "averageTenure": 0.00000000000000000000}, "attrition": {"percentage": 0.00}, "disability": {"percentage": 0}, "statistics": {"totalLeavers": 0, "futureJoiners": 0, "totalHeadcount": 4, "totalVacancies": 4, "totalContractors": 0}, "generatedAt": "2025-10-04 01:04:10.523628+05:30", "ageDistribution": {"groups": [{"name": "Younger than 25", "count": 0}, {"name": "25-45", "count": 0}, {"name": "45-60", "count": 0}, {"name": "60+", "count": 0}], "averageAge": 0}}	2025-10-04 01:04:10.523628	\N	t
\.


--
-- TOC entry 4571 (class 0 OID 18890)
-- Dependencies: 275
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
-- TOC entry 4573 (class 0 OID 18907)
-- Dependencies: 277
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
-- TOC entry 4575 (class 0 OID 18913)
-- Dependencies: 279
-- Data for Name: system_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.system_settings (id, total_annual_leaves, allow_half_day, approval_workflow, created_at, updated_at) FROM stdin;
1	15	t	manager_then_hr	2025-08-29 20:09:54.234378	2025-09-09 19:24:34.522537
\.


--
-- TOC entry 4519 (class 0 OID 18563)
-- Dependencies: 221
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, password, role, temp_password, first_name, last_name, phone, address, emergency_contact_name, emergency_contact_phone, emergency_contact_relationship, created_at, updated_at, emergency_contact_name2, emergency_contact_phone2, emergency_contact_relationship2, is_first_login) FROM stdin;
118	stalinnithin31@gmail.com	$2a$10$C8zDkRkTRBjIgr68ajjEGuSl2DH7ClYyWRRJKYiiIMqenCsEm3CIa	manager	\N	Luthen	S	\N	\N	\N	\N	\N	2025-09-12 18:34:28.771547	2025-09-16 19:42:57.000141	\N	\N	\N	t
153	mahendra@nxzen.com	$2a$10$lAHWYj/oWt8aiz0QDNmR6.22FQXIXIcOKRq4uRwKkS8bfv6tyfoMe	employee	\N	Mahendra	Teja	\N	\N	\N	\N	\N	2025-09-17 12:37:55.46162	2025-09-17 12:43:41.230483	\N	\N	\N	t
1	hr@nxzen.com	$2a$10$Pdb6iKx2lQ2hbI31N.XSWeQgpjAQ8oaS3YYWmphKo7DYNcC9SLSTe	hr	\N	HR	Manager	\N	\N	\N	\N	\N	2025-09-04 03:20:17.624157	2025-09-18 14:11:25.447886	\N	\N	\N	f
124	rishitha.jaligam@nxzen.com	$2a$10$/sUsNoiMTzkcJnvnzby5fOXDDJFTErmqBDpzzUrGjfZ2/FkQc7eXa	employee	\N	Rishitha	Jaligam	\N	\N	\N	\N	\N	2025-09-15 12:58:09.742393	2025-09-15 13:11:31.593591	\N	\N	\N	t
194	dori7728@gmail.com		employee	69gTRF8A	Dori	D	\N	\N	\N	\N	\N	2025-09-26 00:15:16.994353	2025-09-26 00:15:16.994353	\N	\N	\N	t
197	dori77284@gmail.com	$2a$10$phhLnLmXfHvMhvRyCE3YCevPOJ5FfGOj4otb.CSGlLBpYIYc0ngFq	manager	\N	Dori	D	\N	\N	\N	\N	\N	2025-09-26 00:38:10.838473	2025-09-26 00:39:13.73957	\N	\N	\N	t
\.


--
-- TOC entry 4680 (class 0 OID 0)
-- Dependencies: 215
-- Name: adp_payroll_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adp_payroll_id_seq', 1, true);


--
-- TOC entry 4681 (class 0 OID 0)
-- Dependencies: 217
-- Name: attendance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attendance_id_seq', 149, true);


--
-- TOC entry 4682 (class 0 OID 0)
-- Dependencies: 219
-- Name: attendance_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attendance_settings_id_seq', 6318, true);


--
-- TOC entry 4683 (class 0 OID 0)
-- Dependencies: 224
-- Name: comp_off_balances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comp_off_balances_id_seq', 5, true);


--
-- TOC entry 4684 (class 0 OID 0)
-- Dependencies: 226
-- Name: company_emails_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.company_emails_id_seq', 251, true);


--
-- TOC entry 4685 (class 0 OID 0)
-- Dependencies: 228
-- Name: departments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.departments_id_seq', 4915, true);


--
-- TOC entry 4686 (class 0 OID 0)
-- Dependencies: 230
-- Name: document_collection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.document_collection_id_seq', 682, true);


--
-- TOC entry 4687 (class 0 OID 0)
-- Dependencies: 232
-- Name: document_reminder_mails_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.document_reminder_mails_id_seq', 19, true);


--
-- TOC entry 4688 (class 0 OID 0)
-- Dependencies: 234
-- Name: document_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.document_templates_id_seq', 25616, true);


--
-- TOC entry 4689 (class 0 OID 0)
-- Dependencies: 236
-- Name: documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.documents_id_seq', 1, false);


--
-- TOC entry 4690 (class 0 OID 0)
-- Dependencies: 239
-- Name: employee_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_documents_id_seq', 158, true);


--
-- TOC entry 4691 (class 0 OID 0)
-- Dependencies: 241
-- Name: employee_forms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_forms_id_seq', 77, true);


--
-- TOC entry 4692 (class 0 OID 0)
-- Dependencies: 242
-- Name: employee_master_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_master_id_seq', 180, true);


--
-- TOC entry 4693 (class 0 OID 0)
-- Dependencies: 244
-- Name: employees_combined_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employees_combined_id_seq', 10, true);


--
-- TOC entry 4694 (class 0 OID 0)
-- Dependencies: 246
-- Name: expense_attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.expense_attachments_id_seq', 1, false);


--
-- TOC entry 4695 (class 0 OID 0)
-- Dependencies: 248
-- Name: expense_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.expense_categories_id_seq', 12, true);


--
-- TOC entry 4696 (class 0 OID 0)
-- Dependencies: 250
-- Name: expense_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.expense_requests_id_seq', 17, true);


--
-- TOC entry 4697 (class 0 OID 0)
-- Dependencies: 252
-- Name: expenses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.expenses_id_seq', 48, true);


--
-- TOC entry 4698 (class 0 OID 0)
-- Dependencies: 254
-- Name: leave_balances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.leave_balances_id_seq', 36, true);


--
-- TOC entry 4699 (class 0 OID 0)
-- Dependencies: 256
-- Name: leave_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.leave_requests_id_seq', 39, true);


--
-- TOC entry 4700 (class 0 OID 0)
-- Dependencies: 258
-- Name: leave_type_balances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.leave_type_balances_id_seq', 168, true);


--
-- TOC entry 4701 (class 0 OID 0)
-- Dependencies: 260
-- Name: leave_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.leave_types_id_seq', 15061, true);


--
-- TOC entry 4702 (class 0 OID 0)
-- Dependencies: 262
-- Name: manager_employee_mapping_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.manager_employee_mapping_id_seq', 63, true);


--
-- TOC entry 4703 (class 0 OID 0)
-- Dependencies: 264
-- Name: managers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.managers_id_seq', 68, true);


--
-- TOC entry 4704 (class 0 OID 0)
-- Dependencies: 266
-- Name: migration_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migration_log_id_seq', 7, true);


--
-- TOC entry 4705 (class 0 OID 0)
-- Dependencies: 268
-- Name: onboarded_employees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.onboarded_employees_id_seq', 52, true);


--
-- TOC entry 4706 (class 0 OID 0)
-- Dependencies: 270
-- Name: onboarding_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.onboarding_id_seq', 12, true);


--
-- TOC entry 4707 (class 0 OID 0)
-- Dependencies: 272
-- Name: pnc_monitoring_breakdowns_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pnc_monitoring_breakdowns_id_seq', 1, false);


--
-- TOC entry 4708 (class 0 OID 0)
-- Dependencies: 274
-- Name: pnc_monitoring_reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pnc_monitoring_reports_id_seq', 29, true);


--
-- TOC entry 4709 (class 0 OID 0)
-- Dependencies: 276
-- Name: recruitment_requisitions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recruitment_requisitions_id_seq', 10, true);


--
-- TOC entry 4710 (class 0 OID 0)
-- Dependencies: 278
-- Name: relations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.relations_id_seq', 7, true);


--
-- TOC entry 4711 (class 0 OID 0)
-- Dependencies: 280
-- Name: system_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.system_settings_id_seq', 1, true);


--
-- TOC entry 4712 (class 0 OID 0)
-- Dependencies: 281
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 197, true);


-- Completed on 2025-10-04 01:22:30 IST

--
-- PostgreSQL database dump complete
--

