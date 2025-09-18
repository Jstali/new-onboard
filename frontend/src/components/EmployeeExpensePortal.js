import React, { useState } from "react";
import { FaReceipt, FaHistory, FaHome } from "react-icons/fa";
import EmployeeExpenseRequest from "./EmployeeExpenseRequest";
import EmployeeExpenseHistory from "./EmployeeExpenseHistory";

const EmployeeExpensePortal = ({ onBackToDashboard }) => {
  const [activeTab, setActiveTab] = useState("submit");

  const tabs = [
    {
      id: "submit",
      label: "Submit Expense",
      icon: FaReceipt,
    },
    {
      id: "history",
      label: "Expense History",
      icon: FaHistory,
    },
  ];

  return (
    <div className="min-h-screen bg-iridescent-pearl">
      {/* Header with Tab Navigation */}
      <div className="bg-white shadow-sm border-b border-deep-space-black/10 sticky top-0 z-10">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex gap-5 py-4">
            <button
              onClick={onBackToDashboard}
              className="flex items-center px-3 py-2 text-sm font-medium text-deep-space-black bg-white border border-deep-space-black/20 hover:bg-neon-violet/20 rounded-xl transition-colors duration-200"
            >
              <FaHome className="w-4 h-4 mr-2" />
              Home
            </button>
            {/* Left side - Title and Home button */}
            <div className="flex justify-between space-x-4">
              <h1 className="text-2xl font-bold text-deep-space-black">
                Expense Management
              </h1>
            </div>
          </div>

          {/* Tab Navigation */}
          <div className="border-b border-deep-space-black/10">
            <nav className="-mb-px flex space-x-8">
              {tabs.map((tab) => {
                const Icon = tab.icon;
                const isActive = activeTab === tab.id;

                return (
                  <button
                    key={tab.id}
                    onClick={() => setActiveTab(tab.id)}
                    className={`group relative whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm transition-all duration-300 ease-in-out ${
                      isActive
                        ? "border-lumen-green text-lumen-green"
                        : "border-transparent text-deep-space-black/70 hover:text-deep-space-black hover:border-deep-space-black/30"
                    }`}
                  >
                    <div className="flex items-center space-x-2">
                      <Icon
                        className={`transition-all duration-300 ${
                          isActive
                            ? "text-lumen-green transform scale-110"
                            : "text-deep-space-black/60 group-hover:text-deep-space-black"
                        }`}
                      />
                      <span>{tab.label}</span>
                    </div>

                    {/* Active indicator with animation */}
                    {isActive && (
                      <div className="absolute inset-x-0 bottom-0 h-0.5 bg-gradient-to-r from-lumen-green to-lumen-green/80 rounded-t-full animate-pulse"></div>
                    )}
                  </button>
                );
              })}
            </nav>
          </div>
        </div>
      </div>

      {/* Tab Content with Smooth Transition */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
        <div className="relative">
          {/* Submit Expense Content */}
          <div
            className={`transition-all duration-500 ease-in-out ${
              activeTab === "submit"
                ? "opacity-100 transform translate-x-0 visible"
                : "opacity-0 transform translate-x-full invisible absolute inset-0"
            }`}
          >
            {activeTab === "submit" && (
              <div className="animate-fadeIn">
                <EmployeeExpenseRequest />
              </div>
            )}
          </div>

          {/* Expense History Content */}
          <div
            className={`transition-all duration-500 ease-in-out ${
              activeTab === "history"
                ? "opacity-100 transform translate-x-0 visible"
                : "opacity-0 transform -translate-x-full invisible absolute inset-0"
            }`}
          >
            {activeTab === "history" && (
              <div className="animate-fadeIn">
                <EmployeeExpenseHistory
                  onNavigateToSubmit={() => setActiveTab("submit")}
                />
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default EmployeeExpensePortal;
