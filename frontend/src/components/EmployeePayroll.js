import React, { useState, useEffect } from "react";
import {
  FaIdCard,
  FaCalendarAlt,
  FaUser,
  FaBuilding,
  FaMapMarkerAlt,
  FaDollarSign,
  FaInfoCircle,
} from "react-icons/fa";
import axios from "axios";
import toast from "react-hot-toast";

const EmployeePayroll = () => {
  const [payrollData, setPayrollData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    fetchPayrollData();
  }, []);

  const fetchPayrollData = async () => {
    try {
      setLoading(true);
      const response = await axios.get("/employee-payroll/my-payroll");

      if (response.data.success) {
        setPayrollData(response.data.data);
        setError("");
      } else {
        setError(response.data.error);
      }
    } catch (error) {
      console.error("Error fetching payroll data:", error);
      if (error.response?.status === 404) {
        setError(
          "Payroll details not found. Please contact HR for assistance."
        );
      } else {
        setError("Failed to fetch payroll details. Please try again later.");
      }
    } finally {
      setLoading(false);
    }
  };

  const formatDate = (dateString) => {
    if (!dateString) return "Not Available";
    const date = new Date(dateString);
    return date.toLocaleDateString("en-US", {
      year: "numeric",
      month: "long",
      day: "numeric",
    });
  };

  const getStatusBadge = (status) => {
    const statusClasses = {
      active: "bg-green-100 text-green-800",
      inactive: "bg-gray-100 text-gray-800",
      terminated: "bg-red-100 text-red-800",
    };
    return (
      <span
        className={`px-3 py-1 rounded-full text-sm font-medium ${
          statusClasses[status] || "bg-gray-100 text-gray-800"
        }`}
      >
        {status?.charAt(0).toUpperCase() + status?.slice(1) || "Unknown"}
      </span>
    );
  };

  const getTypeBadge = (type) => {
    const typeClasses = {
      "Full-Time": "bg-blue-100 text-blue-800",
      Contract: "bg-yellow-100 text-yellow-800",
      Intern: "bg-purple-100 text-purple-800",
      Manager: "bg-indigo-100 text-indigo-800",
    };
    return (
      <span
        className={`px-3 py-1 rounded-full text-sm font-medium ${
          typeClasses[type] || "bg-gray-100 text-gray-800"
        }`}
      >
        {type || "Not Specified"}
      </span>
    );
  };

  if (loading) {
    return (
      <div className="flex justify-center items-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
        <div className="flex items-center justify-center text-center">
          <div>
            <FaInfoCircle className="w-16 h-16 text-yellow-500 mx-auto mb-4" />
            <h3 className="text-lg font-medium text-gray-900 mb-2">
              Payroll Information Not Available
            </h3>
            <p className="text-gray-600 mb-4">{error}</p>
            <button
              onClick={fetchPayrollData}
              className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors"
            >
              Try Again
            </button>
          </div>
        </div>
      </div>
    );
  }

  if (!payrollData) {
    return (
      <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
        <div className="text-center">
          <h3 className="text-lg font-medium text-gray-900 mb-2">
            No Payroll Data Found
          </h3>
          <p className="text-gray-600">
            Please contact HR to set up your payroll information.
          </p>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
        <div className="flex items-center justify-between">
          <div>
            <h2 className="text-2xl font-bold text-gray-900">
              Payroll Information
            </h2>
            <p className="text-gray-600">Your employment and payroll details</p>
          </div>
          <div className="flex space-x-2">
            {getStatusBadge(payrollData.status)}
            {getTypeBadge(payrollData.employee_type)}
          </div>
        </div>
      </div>

      {/* Main Information Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* Employee Details */}
        <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
          <div className="flex items-center mb-4">
            <FaUser className="w-6 h-6 text-blue-600 mr-3" />
            <h3 className="text-lg font-semibold text-gray-900">
              Employee Details
            </h3>
          </div>
          <div className="space-y-4">
            <div className="flex justify-between items-center py-2 border-b border-gray-100">
              <span className="text-sm font-medium text-gray-600">
                Employee ID:
              </span>
              <span className="text-sm text-gray-900 font-mono">
                {payrollData.employee_id}
              </span>
            </div>
            <div className="flex justify-between items-center py-2 border-b border-gray-100">
              <span className="text-sm font-medium text-gray-600">
                Full Name:
              </span>
              <span className="text-sm text-gray-900">
                {payrollData.employee_name}
              </span>
            </div>
            <div className="flex justify-between items-center py-2 border-b border-gray-100">
              <span className="text-sm font-medium text-gray-600">
                Company Email:
              </span>
              <span className="text-sm text-gray-900">
                {payrollData.company_email}
              </span>
            </div>
            <div className="flex justify-between items-center py-2">
              <span className="text-sm font-medium text-gray-600">
                Designation:
              </span>
              <span className="text-sm text-gray-900">
                {payrollData.designation || "Not Specified"}
              </span>
            </div>
          </div>
        </div>

        {/* Employment Details */}
        <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
          <div className="flex items-center mb-4">
            <FaCalendarAlt className="w-6 h-6 text-green-600 mr-3" />
            <h3 className="text-lg font-semibold text-gray-900">
              Employment Details
            </h3>
          </div>
          <div className="space-y-4">
            <div className="flex justify-between items-center py-2 border-b border-gray-100">
              <span className="text-sm font-medium text-gray-600">
                Joining Date:
              </span>
              <span className="text-sm text-gray-900">
                {formatDate(payrollData.joining_date)}
              </span>
            </div>
            <div className="flex justify-between items-center py-2 border-b border-gray-100">
              <span className="text-sm font-medium text-gray-600">
                Payroll Start Month:
              </span>
              <span className="text-sm text-gray-900">
                {formatDate(payrollData.payroll_starting_month)}
              </span>
            </div>
            <div className="flex justify-between items-center py-2 border-b border-gray-100">
              <span className="text-sm font-medium text-gray-600">
                Employee Type:
              </span>
              <span className="text-sm text-gray-900">
                {payrollData.employee_type}
              </span>
            </div>
            <div className="flex justify-between items-center py-2">
              <span className="text-sm font-medium text-gray-600">Status:</span>
              <span className="text-sm text-gray-900">
                {payrollData.status?.charAt(0).toUpperCase() +
                  payrollData.status?.slice(1)}
              </span>
            </div>
          </div>
        </div>
      </div>

      {/* Additional Information */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* Department & Location */}
        <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
          <div className="flex items-center mb-4">
            <FaBuilding className="w-6 h-6 text-purple-600 mr-3" />
            <h3 className="text-lg font-semibold text-gray-900">
              Department & Location
            </h3>
          </div>
          <div className="space-y-4">
            <div className="flex justify-between items-center py-2 border-b border-gray-100">
              <span className="text-sm font-medium text-gray-600">
                Department:
              </span>
              <span className="text-sm text-gray-900">
                {payrollData.department || "Not Assigned"}
              </span>
            </div>
            <div className="flex justify-between items-center py-2 border-b border-gray-100">
              <span className="text-sm font-medium text-gray-600">
                Work Location:
              </span>
              <span className="text-sm text-gray-900">
                {payrollData.work_location || "Not Specified"}
              </span>
            </div>
            <div className="flex justify-between items-center py-2">
              <span className="text-sm font-medium text-gray-600">
                Salary Band:
              </span>
              <span className="text-sm text-gray-900">
                {payrollData.salary_band || "Not Specified"}
              </span>
            </div>
          </div>
        </div>

        {/* Management Information */}
        <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
          <div className="flex items-center mb-4">
            <FaIdCard className="w-6 h-6 text-indigo-600 mr-3" />
            <h3 className="text-lg font-semibold text-gray-900">
              Management Information
            </h3>
          </div>
          <div className="space-y-4">
            <div className="flex justify-between items-center py-2 border-b border-gray-100">
              <span className="text-sm font-medium text-gray-600">
                Primary Manager:
              </span>
              <span className="text-sm text-gray-900">
                {payrollData.manager_name || "Not Assigned"}
              </span>
            </div>
            {payrollData.manager2_name && (
              <div className="flex justify-between items-center py-2 border-b border-gray-100">
                <span className="text-sm font-medium text-gray-600">
                  Secondary Manager:
                </span>
                <span className="text-sm text-gray-900">
                  {payrollData.manager2_name}
                </span>
              </div>
            )}
            {payrollData.manager3_name && (
              <div className="flex justify-between items-center py-2">
                <span className="text-sm font-medium text-gray-600">
                  Tertiary Manager:
                </span>
                <span className="text-sm text-gray-900">
                  {payrollData.manager3_name}
                </span>
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Draft Status Notice */}
      {payrollData.is_draft && (
        <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
          <div className="flex items-center">
            <FaInfoCircle className="w-5 h-5 text-yellow-600 mr-3" />
            <div>
              <h4 className="text-sm font-medium text-yellow-800">
                Draft Status
              </h4>
              <p className="text-sm text-yellow-700 mt-1">
                Your payroll information is currently in draft status. Please
                contact HR for final confirmation.
              </p>
            </div>
          </div>
        </div>
      )}

      {/* Last Updated */}
      <div className="bg-gray-50 rounded-lg p-4">
        <p className="text-xs text-gray-500 text-center">
          Last updated: {new Date().toLocaleDateString()} | For any
          discrepancies, please contact HR
        </p>
      </div>
    </div>
  );
};

export default EmployeePayroll;
