import React, { useState, useEffect } from "react";
import { useAuth } from "../contexts/AuthContext";
import { useNavigate } from "react-router-dom";
import { FaHome } from "react-icons/fa";
import { toast } from "react-hot-toast";
import ADPPayrollForm from "./ADPPayrollForm";
import axios from "axios";

const Profile = () => {
  const { user, changePassword, logout } = useAuth();
  const navigate = useNavigate();
  const [isChangingPassword, setIsChangingPassword] = useState(false);
  const [passwordData, setPasswordData] = useState({
    currentPassword: "",
    newPassword: "",
    confirmPassword: "",
  });
  const [loading, setLoading] = useState(false);
  const [employeeData, setEmployeeData] = useState(null);
  const [activeTab, setActiveTab] = useState("profile");

  useEffect(() => {
    fetchEmployeeData();
  }, [user]);

  const fetchEmployeeData = async () => {
    try {
      const response = await axios.get("/employee/profile");
      if (response.data.success && response.data.employee) {
        setEmployeeData(response.data.employee);
      }
    } catch (error) {
      console.error("Error fetching employee data:", error);
    }
  };

  const handlePasswordChange = async (e) => {
    e.preventDefault();

    if (passwordData.newPassword !== passwordData.confirmPassword) {
      toast.error("New passwords do not match!");
      return;
    }

    if (passwordData.newPassword.length < 6) {
      toast.error("New password must be at least 6 characters long!");
      return;
    }

    setLoading(true);
    try {
      const result = await changePassword(
        passwordData.currentPassword,
        passwordData.newPassword
      );

      if (result.success) {
        setPasswordData({
          currentPassword: "",
          newPassword: "",
          confirmPassword: "",
        });
        setIsChangingPassword(false);
        toast.success("Password changed successfully!");
      }
    } catch (error) {
      console.error("Password change error:", error);
    } finally {
      setLoading(false);
    }
  };

  const handleInputChange = (e) => {
    setPasswordData({
      ...passwordData,
      [e.target.name]: e.target.value,
    });
  };

  return (
    <div className="min-h-screen bg-iridescent-pearl py-8">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="bg-white shadow rounded-lg border border-deep-space-black/10">
          {/* Header */}
          <div className="px-6 py-4 border-b border-deep-space-black/10">
            <div className="flex items-center space-x-4">
              <button
                onClick={() => navigate("/employee/dashboard")}
                className="flex items-center px-3 py-2 text-sm font-medium text-deep-space-black bg-white border border-deep-space-black/20 hover:bg-neon-violet/20 rounded-xl transition-colors duration-200"
              >
                <FaHome className="w-4 h-4 mr-2" />
                Home
              </button>
              <div>
                <h1 className="brand-heading-md text-deep-space-black">
                  Profile Settings
                </h1>
                <p className="brand-body-sm text-deep-space-black/70">
                  Manage your account settings and password
                </p>
              </div>
            </div>
          </div>

          {/* Tab Navigation */}
          <div className="border-b border-deep-space-black/10">
            <nav className="flex space-x-8 px-6">
              <button
                onClick={() => setActiveTab("profile")}
                className={`py-4 px-1 border-b-2 font-medium text-sm ${
                  activeTab === "profile"
                    ? "border-neon-violet text-neon-violet"
                    : "border-transparent text-deep-space-black/70 hover:text-deep-space-black hover:border-gray-300"
                }`}
              >
                Profile Settings
              </button>
              <button
                onClick={() => setActiveTab("adp-payroll")}
                className={`py-4 px-1 border-b-2 font-medium text-sm ${
                  activeTab === "adp-payroll"
                    ? "border-neon-violet text-neon-violet"
                    : "border-transparent text-deep-space-black/70 hover:text-deep-space-black hover:border-gray-300"
                }`}
              >
                Payroll
              </button>
            </nav>
          </div>

          <div className="px-6 py-6">
            {activeTab === "profile" ? (
              <>
                {/* User Information */}
                <div className="mb-8">
                  <h2 className="brand-subheading-md text-deep-space-black mb-4">
                    User Information
                  </h2>
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                      <label className="brand-body-sm text-deep-space-black/70 block">
                        Email
                      </label>
                      <p className="mt-1 brand-body-md text-deep-space-black">
                        {user?.email}
                      </p>
                    </div>
                    <div>
                      <label className="brand-body-sm text-deep-space-black/70 block">
                        Role
                      </label>
                      <p className="mt-1 brand-body-md text-deep-space-black capitalize">
                        {user?.role}
                      </p>
                    </div>
                    {user?.first_name && (
                      <div>
                        <label className="brand-body-sm text-deep-space-black/70 block">
                          First Name
                        </label>
                        <p className="mt-1 brand-body-md text-deep-space-black">
                          {user.first_name}
                        </p>
                      </div>
                    )}
                    {user?.last_name && (
                      <div>
                        <label className="brand-body-sm text-deep-space-black/70 block">
                          Last Name
                        </label>
                        <p className="mt-1 brand-body-md text-deep-space-black">
                          {user.last_name}
                        </p>
                      </div>
                    )}
                  </div>
                </div>

                {/* Password Change Section */}
                <div className="border-t border-deep-space-black/10 pt-6">
                  <div className="flex items-center justify-between mb-4">
                    <h2 className="brand-subheading-md text-deep-space-black">
                      Change Password
                    </h2>
                    <button
                      onClick={() => setIsChangingPassword(!isChangingPassword)}
                      className="inline-flex items-center px-3 py-2 border border-deep-space-black/20 shadow-sm brand-body-sm rounded-md text-deep-space-black bg-white hover:bg-neon-violet hover:text-white focus:outline-none focus:ring-2 focus:ring-lumen-green transition-all duration-200"
                    >
                      {isChangingPassword ? "Cancel" : "Change Password"}
                    </button>
                  </div>

                  {isChangingPassword && (
                    <form onSubmit={handlePasswordChange} className="space-y-4">
                      <div>
                        <label
                          htmlFor="currentPassword"
                          className="brand-body-sm text-deep-space-black block"
                        >
                          Current Password
                        </label>
                        <input
                          type="password"
                          id="currentPassword"
                          name="currentPassword"
                          value={passwordData.currentPassword}
                          onChange={handleInputChange}
                          required
                          className="mt-1 block w-full px-3 py-2 border border-deep-space-black/20 rounded-md shadow-sm focus:outline-none focus:ring-lumen-green focus:border-lumen-green bg-gray-100 text-deep-space-black brand-body-md"
                        />
                      </div>

                      <div>
                        <label
                          htmlFor="newPassword"
                          className="brand-body-sm text-deep-space-black block"
                        >
                          New Password
                        </label>
                        <input
                          type="password"
                          id="newPassword"
                          name="newPassword"
                          value={passwordData.newPassword}
                          onChange={handleInputChange}
                          required
                          minLength={6}
                          className="mt-1 block w-full px-3 py-2 border border-deep-space-black/20 rounded-md shadow-sm focus:outline-none focus:ring-lumen-green focus:border-lumen-green bg-gray-100 text-deep-space-black brand-body-md"
                        />
                      </div>

                      <div>
                        <label
                          htmlFor="confirmPassword"
                          className="brand-body-sm text-deep-space-black block"
                        >
                          Confirm New Password
                        </label>
                        <input
                          type="password"
                          id="confirmPassword"
                          name="confirmPassword"
                          value={passwordData.confirmPassword}
                          onChange={handleInputChange}
                          required
                          minLength={6}
                          className="mt-1 block w-full px-3 py-2 border border-deep-space-black/20 rounded-md shadow-sm focus:outline-none focus:ring-lumen-green focus:border-lumen-green bg-gray-100 text-deep-space-black brand-body-md"
                        />
                      </div>

                      <div className="flex justify-end space-x-3">
                        <button
                          type="button"
                          onClick={() => setIsChangingPassword(false)}
                          className="inline-flex items-center px-4 py-2 border border-deep-space-black/20 shadow-sm brand-body-sm rounded-md text-deep-space-black bg-white hover:bg-neon-violet hover:text-white focus:outline-none focus:ring-2 focus:ring-lumen-green transition-all duration-200"
                        >
                          Cancel
                        </button>
                        <button
                          type="submit"
                          disabled={loading}
                          className="inline-flex items-center px-4 py-2 border border-transparent brand-body-sm rounded-md shadow-sm text-deep-space-black bg-lumen-green hover:bg-neon-violet hover:text-white focus:outline-none focus:ring-2 focus:ring-lumen-green disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200"
                        >
                          {loading ? "Changing..." : "Change Password"}
                        </button>
                      </div>
                    </form>
                  )}
                </div>

                {/* Logout Section */}
                <div className="border-t border-deep-space-black/10 pt-6">
                  <div className="flex items-center justify-between">
                    <div>
                      <h2 className="brand-subheading-md text-deep-space-black">
                        Sign Out
                      </h2>
                      <p className="mt-1 brand-body-sm text-deep-space-black/70">
                        Sign out of your account
                      </p>
                    </div>
                    <button
                      onClick={logout}
                      className="inline-flex items-center px-4 py-2 border border-transparent brand-body-sm rounded-md shadow-sm text-white bg-brand-coral hover:bg-deep-space-black focus:outline-none focus:ring-2 focus:ring-brand-coral transition-all duration-200"
                    >
                      Sign Out
                    </button>
                  </div>
                </div>
              </>
            ) : (
              /* ADP Payroll Tab */
              <div>
                {employeeData ? (
                  <ADPPayrollForm
                    employeeId={employeeData.employee_id}
                    isReadOnly={false}
                  />
                ) : (
                  <div className="text-center py-8">
                    <p className="text-deep-space-black/70">
                      Loading employee data...
                    </p>
                  </div>
                )}
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default Profile;
