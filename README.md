# Employee Onboarding & Management System

A comprehensive employee onboarding and management system built with React and Node.js.

## Project Structure

```
onboard/
├── frontend/                 # React frontend application
│   ├── src/
│   │   ├── components/      # React components
│   │   ├── contexts/        # React contexts
│   │   └── styles/          # CSS styles
│   ├── public/              # Static assets
│   └── package.json
├── backend/                 # Node.js/Express backend
│   ├── routes/              # API routes
│   ├── middleware/          # Express middleware
│   ├── config/              # Configuration files
│   ├── utils/               # Utility functions
│   ├── scripts/             # Database scripts
│   └── uploads/             # File uploads
├── docs/                    # Documentation
├── scripts/                 # Deployment and setup scripts
├── docker-compose.yml       # Docker configuration
└── package.json            # Root package.json
```

## Features

- **Employee Onboarding**: Complete onboarding workflow
- **Attendance Management**: Track employee attendance
- **Leave Management**: Handle leave requests and approvals
- **Document Management**: Upload and manage employee documents
- **HR Dashboard**: Comprehensive HR management interface
- **Manager Portal**: Manager-specific features and approvals
- **Role-based Access**: Different interfaces for HR, Managers, and Employees

## Quick Start

1. **Install Dependencies**

   ```bash
   npm run install-all
   ```

2. **Setup Database**

   ```bash
   npm run setup-database
   ```

3. **Start Development**

   ```bash
   npm run dev
   ```

4. **Access Application**
   - Frontend: http://localhost:3001
   - Backend: http://localhost:5001

## Available Scripts

- `npm run dev` - Start both frontend and backend in development mode
- `npm run server` - Start only the backend server
- `npm run client` - Start only the frontend development server
- `npm run build` - Build the frontend for production
- `npm run setup-database` - Setup the database
- `npm run test-database` - Test database connection

## Technology Stack

### Frontend

- React 18
- Tailwind CSS
- React Router
- Axios
- React Hot Toast

### Backend

- Node.js
- Express.js
- PostgreSQL
- JWT Authentication
- Multer (File Uploads)
- Nodemailer (Email)

## Documentation

See the `docs/` folder for detailed documentation including:

- Setup guides
- Deployment instructions
- API documentation
- Database schema

## License

MIT
