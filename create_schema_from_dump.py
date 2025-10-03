#!/usr/bin/env python3
import re
import sys

def parse_copy_statements(sql_file):
    """Parse COPY statements and generate CREATE TABLE statements"""
    
    with open(sql_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Find all COPY statements
    copy_pattern = r'COPY public\.(\w+) \((.*?)\) FROM stdin;'
    matches = re.findall(copy_pattern, content, re.DOTALL)
    
    create_statements = []
    
    for table_name, columns_str in matches:
        columns = [col.strip() for col in columns_str.split(',')]
        
        # Generate CREATE TABLE statement
        create_stmt = f"CREATE TABLE IF NOT EXISTS {table_name} (\n"
        col_definitions = []
        
        for col in columns:
            col_type = guess_column_type(col)
            col_definitions.append(f"    {col} {col_type}")
        
        create_stmt += ",\n".join(col_definitions)
        create_stmt += "\n);\n\n"
        create_statements.append(create_stmt)
    
    return create_statements

def guess_column_type(column_name):
    """Guess PostgreSQL data type based on column name"""
    col_lower = column_name.lower()
    
    # Primary keys
    if col_lower == 'id':
        return 'SERIAL PRIMARY KEY'
    
    # Foreign keys and IDs
    if col_lower.endswith('_id') or col_lower == 'employee_id' or col_lower == 'user_id':
        return 'INTEGER'
    
    # Booleans
    if col_lower.startswith('is_') or col_lower.startswith('has_') or col_lower.startswith('allow_'):
        return 'BOOLEAN'
    if col_lower in ['is_active', 'is_primary', 'is_required', 'is_draft', 'half_day', 'tax_included', 
                      'esi_above_wage_limit', 'already_member_in_pf', 'already_member_in_pension',
                      'withdrawn_pf_and_pension', 'pf_opt_out', 'esi_opt_out', 'ot_eligibility',
                      'auto_shift_eligibility', 'mobile_user', 'web_punch', 'attendance_exception_eligibility']:
        return 'BOOLEAN'
    
    # Dates
    if 'date' in col_lower or col_lower == 'doj' or col_lower == 'dob':
        return 'DATE'
    
    # Timestamps
    if col_lower in ['created_at', 'updated_at', 'uploaded_at', 'submitted_at', 'reviewed_at', 
                      'approved_at', 'sent_at', 'completed_at', 'filled_date', 'posted_date', 'closing_date']:
        return 'TIMESTAMP'
    if '_at' in col_lower or '_date' in col_lower:
        return 'TIMESTAMP'
    
    # Numeric types
    if col_lower in ['amount', 'total_reimbursable', 'total_allocated', 'leaves_taken', 'leaves_remaining',
                      'total_earned', 'comp_off_taken', 'comp_off_remaining', 'leave_balance_before',
                      'total_leave_days', 'leaves_taken', 'score']:
        return 'DECIMAL(10,2)'
    if col_lower in ['year', 'file_size', 'resend_count', 'number_of_children', 'count', 'percentage',
                      'min_experience', 'max_experience', 'max_days']:
        return 'INTEGER'
    if col_lower == 'hours':
        return 'DECIMAL(4,2)'
    
    # JSON/JSONB
    if col_lower in ['form_data', 'files', 'draft_data', 'documents_uploaded', 'report_data', 
                      'required_skills', 'preferred_skills']:
        return 'JSONB'
    
    # Text/VARCHAR
    if col_lower in ['description', 'reason', 'notes', 'review_notes', 'approval_notes', 'details',
                      'address', 'address1', 'address2', 'address3']:
        return 'TEXT'
    
    # Specific fields
    if col_lower in ['email', 'alternate_email', 'company_email', 'employee_email']:
        return 'VARCHAR(255)'
    if col_lower == 'password':
        return 'VARCHAR(255)'
    if col_lower in ['series', 'approval_token']:
        return 'VARCHAR(255)'
    if col_lower in ['status', 'role', 'type', 'category', 'priority', 'payment_mode', 'currency']:
        return 'VARCHAR(50)'
    if 'name' in col_lower:
        return 'VARCHAR(255)'
    if col_lower == 'phone' or 'phone' in col_lower or col_lower == 'mobile_number':
        return 'VARCHAR(20)'
    if col_lower in ['pincode', 'code']:
        return 'VARCHAR(20)'
    if 'url' in col_lower or 'path' in col_lower or 'file' in col_lower:
        return 'VARCHAR(500)'
    
    # Default
    return 'TEXT'

if __name__ == '__main__':
    sql_file = '/Users/stalin_j/onboard/onboard/shibin.sql'
    output_file = '/Users/stalin_j/onboard/onboard/shibin_schema_generated.sql'
    
    print("🔍 Parsing shibin.sql...")
    create_statements = parse_copy_statements(sql_file)
    
    print(f"📝 Found {len(create_statements)} tables")
    
    # Write to output file
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("-- Auto-generated schema from shibin.sql\n")
        f.write("-- Generated for PostgreSQL\n\n")
        f.write("SET client_encoding = 'UTF8';\n")
        f.write("SET standard_conforming_strings = on;\n\n")
        for stmt in create_statements:
            f.write(stmt)
    
    print(f"✅ Schema file created: {output_file}")
    print(f"📊 Total tables: {len(create_statements)}")



