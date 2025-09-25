import React, { useState, useEffect } from "react";
import {
  FaUsers,
  FaUserClock,
  FaSignOutAlt,
  FaCalendarPlus,
  FaChartBar,
  FaSync,
} from "react-icons/fa";
import axios from "axios";
import toast from "react-hot-toast";

const HRPNCMonitoring = () => {
  const [reportData, setReportData] = useState(null);
  const [loading, setLoading] = useState(false);
  const [selectedMonth, setSelectedMonth] = useState("");
  const [availableMonths, setAvailableMonths] = useState([]);

  // Initialize with current month
  useEffect(() => {
    const currentDate = new Date();
    const currentMonth = `${currentDate.getFullYear()}-${String(
      currentDate.getMonth() + 1
    ).padStart(2, "0")}`;
    setSelectedMonth(currentMonth);

    // Generate available months (last 12 months)
    const months = [];
    for (let i = 0; i < 12; i++) {
      const date = new Date(
        currentDate.getFullYear(),
        currentDate.getMonth() - i,
        1
      );
      const monthStr = `${date.getFullYear()}-${String(
        date.getMonth() + 1
      ).padStart(2, "0")}`;
      months.push({
        value: monthStr,
        label: date.toLocaleDateString("en-US", {
          year: "numeric",
          month: "long",
        }),
      });
    }
    setAvailableMonths(months);
  }, []);

  // Fetch report data when month changes
  useEffect(() => {
    if (selectedMonth) {
      fetchReportData();
    }
  }, [selectedMonth]); // eslint-disable-line react-hooks/exhaustive-deps

  const fetchReportData = async () => {
    if (!selectedMonth) return;

    setLoading(true);
    try {
      console.log(
        `📊 Fetching P&C Monthly Monitoring Report for ${selectedMonth}`
      );
      const response = await axios.get(
        `/hr/pnc-monitoring?month=${selectedMonth}`
      );

      console.log("✅ Report data fetched:", response.data);
      setReportData(response.data);
      toast.success("Report data loaded successfully");
    } catch (error) {
      console.error("❌ Error fetching report data:", error);
      toast.error(error.response?.data?.error || "Failed to fetch report data");
    } finally {
      setLoading(false);
    }
  };

  const handleRecalculate = async () => {
    if (!selectedMonth) return;

    setLoading(true);
    try {
      console.log(
        `🔄 Recalculating P&C Monthly Monitoring Report for ${selectedMonth}`
      );
      const response = await axios.post(
        `/hr/pnc-monitoring/recalculate`,
        { month: selectedMonth }
      );

      console.log("✅ Report recalculated:", response.data);
      setReportData(response.data);
      toast.success("Report recalculated successfully");
    } catch (error) {
      console.error("❌ Error recalculating report:", error);
      toast.error(
        error.response?.data?.error || "Failed to recalculate report"
      );
    } finally {
      setLoading(false);
    }
  };

  const formatPercentage = (value) => {
    return `${parseFloat(value).toFixed(1)}%`;
  };

  const StatCard = ({ title, value, icon: Icon, color = "blue" }) => {
    const colorClasses = {
      blue: "border-brand-blue text-brand-blue",
      green: "border-lumen-green text-lumen-green",
      red: "border-brand-coral text-brand-coral",
      yellow: "border-brand-yellow text-brand-yellow",
      purple: "border-neon-violet text-neon-violet",
    };

    return (
      <div
        className={`bg-brand-pearl rounded-lg shadow-md p-6 border-l-4 ${
          colorClasses[color] || colorClasses.blue
        } border border-deep-space-black/10`}
      >
        <div className="flex items-center justify-between">
          <div>
            <p className="text-sm font-medium text-deep-space-black/70">
              {title}
            </p>
            <p className="text-2xl font-bold text-deep-space-black">{value}</p>
          </div>
          <Icon
            className={`h-8 w-8 ${colorClasses[color] || colorClasses.blue}`}
          />
        </div>
      </div>
    );
  };

  const MetricCard = ({ title, value, subtitle, color = "gray" }) => {
    const colorClasses = {
      gray: "border-deep-space-black/20 text-deep-space-black",
      green: "border-lumen-green text-lumen-green",
      blue: "border-brand-blue text-brand-blue",
      red: "border-brand-coral text-brand-coral",
      yellow: "border-brand-yellow text-brand-yellow",
      purple: "border-neon-violet text-neon-violet",
    };

    return (
      <div
        className={`bg-brand-pearl rounded-lg shadow-md p-4 border-l-4 ${
          colorClasses[color] || colorClasses.gray
        } border border-deep-space-black/10`}
      >
        <h3 className="text-sm font-medium text-deep-space-black/70 mb-2">
          {title}
        </h3>
        <p className="text-xl font-bold text-deep-space-black">{value}</p>
        {subtitle && (
          <p className="text-xs text-deep-space-black/50 mt-1">{subtitle}</p>
        )}
      </div>
    );
  };

  const DistributionChart = ({ data, title, type = "bar" }) => {
    if (!data || data.length === 0) return null;

    const maxValue = Math.max(...data.map((item) => item.count));

    const brandColors = [
      "bg-brand-blue",
      "bg-lumen-green",
      "bg-brand-yellow",
      "bg-brand-coral",
      "bg-neon-violet",
    ];

    return (
      <div className="bg-brand-pearl rounded-lg shadow-md p-6 border border-deep-space-black/10">
        <h3 className="text-lg font-semibold text-deep-space-black mb-4">
          {title}
        </h3>
        <div className="space-y-3">
          {data.map((item, index) => (
            <div key={index} className="flex items-center justify-between">
              <div className="flex-1">
                <div className="flex justify-between text-sm">
                  <span className="font-medium text-deep-space-black/70">
                    {item.group || item.gender}
                  </span>
                  <span className="text-deep-space-black/60">
                    {item.count} ({item.percentage}%)
                  </span>
                </div>
                <div className="mt-1 bg-deep-space-black/10 rounded-full h-2">
                  <div
                    className={`h-2 rounded-full ${
                      type === "pie"
                        ? brandColors[index % brandColors.length]
                        : "bg-brand-blue"
                    }`}
                    style={{ width: `${(item.count / maxValue) * 100}%` }}
                  ></div>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    );
  };

  const PieChart = ({ data, title }) => {
    if (!data || data.length === 0) return null;

    const colors = [
      "bg-brand-blue",
      "bg-lumen-green",
      "bg-brand-yellow",
      "bg-brand-coral",
      "bg-neon-violet",
    ];

    return (
      <div className="bg-brand-pearl rounded-lg shadow-md p-6 border border-deep-space-black/10">
        <h3 className="text-lg font-semibold text-deep-space-black mb-4">
          {title}
        </h3>
        <div className="grid grid-cols-2 gap-4">
          {data.map((item, index) => (
            <div key={index} className="flex items-center space-x-3">
              <div
                className={`w-4 h-4 rounded-full ${
                  colors[index % colors.length]
                }`}
              ></div>
              <div className="flex-1">
                <p className="text-sm font-medium text-deep-space-black/70">
                  {item.gender}
                </p>
                <p className="text-xs text-deep-space-black/50">
                  {item.count} ({item.percentage}%)
                </p>
              </div>
            </div>
          ))}
        </div>
      </div>
    );
  };

  if (loading && !reportData) {
    return (
      <div className="min-h-screen bg-iridescent-pearl flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-lumen-green mx-auto mb-4"></div>
          <p className="text-deep-space-black/70">
            Loading P&C Monthly Monitoring Report...
          </p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-iridescent-pearl">
      {/* Header */}
      <div className="bg-white shadow-sm border-b border-deep-space-black/10">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <div className="flex justify-between items-center">
            <div>
              <h1 className="text-3xl font-bold text-deep-space-black">
                P&C Monthly Monitoring Report
              </h1>
              <p className="text-deep-space-black/70 mt-1">
                People & Culture monthly metrics and analytics
              </p>
            </div>
            <div className="flex items-center space-x-4">
              {/* Month Selector */}
              <div className="flex items-center space-x-2">
                <label className="text-sm font-medium text-deep-space-black">
                  Month:
                </label>
                <select
                  value={selectedMonth}
                  onChange={(e) => setSelectedMonth(e.target.value)}
                  className="bg-brand-pearl border border-deep-space-black/20 rounded-md px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-lumen-green focus:border-lumen-green text-deep-space-black"
                  disabled={loading}
                >
                  {availableMonths.map((month) => (
                    <option key={month.value} value={month.value}>
                      {month.label}
                    </option>
                  ))}
                </select>
              </div>

              {/* Action Buttons */}
              <button
                onClick={handleRecalculate}
                disabled={loading}
                className="flex items-center px-4 py-2 text-sm font-medium text-deep-space-black bg-lumen-green rounded-lg hover:bg-lumen-green/80 focus:outline-none focus:ring-2 focus:ring-lumen-green disabled:opacity-50"
              >
                <FaSync className={`mr-2 ${loading ? "animate-spin" : ""}`} />
                Recalculate
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
        {loading && (
          <div className="fixed top-4 right-4 bg-lumen-green text-deep-space-black px-4 py-2 rounded-lg shadow-lg z-50">
            <div className="flex items-center space-x-2">
              <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-deep-space-black"></div>
              <span>Updating report...</span>
            </div>
          </div>
        )}

        {reportData && (
          <div className="space-y-6">
            {/* Report Period Info */}
            <div className="bg-brand-pearl border border-deep-space-black/10 rounded-lg p-4">
              <div className="flex items-center justify-between">
                <div>
                  <h2 className="text-lg font-semibold text-deep-space-black">
                    Report Period: {reportData.month}
                  </h2>
                  <p className="text-deep-space-black/70">
                    {reportData.period?.startOfMonth
                      ? new Date(
                          reportData.period.startOfMonth
                        ).toLocaleDateString()
                      : "N/A"}{" "}
                    -{" "}
                    {reportData.period?.endOfMonth
                      ? new Date(
                          reportData.period.endOfMonth
                        ).toLocaleDateString()
                      : "N/A"}
                  </p>
                </div>
                <div className="text-sm text-deep-space-black/60">
                  Generated:{" "}
                  {reportData.generatedAt
                    ? new Date(reportData.generatedAt).toLocaleString()
                    : "N/A"}
                </div>
              </div>
            </div>

            {/* Statistics Cards */}
            <div>
              <h2 className="text-xl font-semibold text-deep-space-black mb-4">
                Key Statistics
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-5 gap-6">
                <StatCard
                  title="Total Headcount"
                  value={reportData.statistics?.totalHeadcount || 0}
                  icon={FaUsers}
                  color="blue"
                />
                <StatCard
                  title="Total Contractors"
                  value={reportData.statistics?.totalContractors || 0}
                  icon={FaUserClock}
                  color="green"
                />
                <StatCard
                  title="Total Leavers"
                  value={reportData.statistics?.totalLeavers || 0}
                  icon={FaSignOutAlt}
                  color="red"
                />
                <StatCard
                  title="Future Joiners"
                  value={reportData.statistics?.futureJoiners || 0}
                  icon={FaCalendarPlus}
                  color="yellow"
                />
                <StatCard
                  title="Live Vacancies"
                  value={reportData.statistics?.totalVacancies || 0}
                  icon={FaChartBar}
                  color="purple"
                />
              </div>
            </div>

            {/* Demographics Section */}
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              {/* Age Distribution */}
              <DistributionChart
                data={reportData.ageDistribution?.groups || []}
                title={`Age Distribution (Avg: ${Math.round(
                  reportData.ageDistribution?.averageAge || 27
                )} years)`}
                type="bar"
              />

              {/* Gender Distribution */}
              <PieChart
                data={reportData.gender || []}
                title="Gender Distribution"
              />
            </div>

            {/* Tenure and Additional Metrics */}
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
              {/* Tenure Distribution */}
              <div className="lg:col-span-2">
                <DistributionChart
                  data={reportData.tenure?.groups || []}
                  title={`Length of Service (Avg: ${
                    reportData.tenure?.averageTenure || 2
                  } years)`}
                  type="bar"
                />
              </div>

              {/* Additional Metrics */}
              <div className="space-y-4">
                <MetricCard
                  title="Disability Percentage"
                  value={formatPercentage(
                    reportData.disability?.percentage || 27
                  )}
                  color="green"
                />
                <MetricCard
                  title="Attrition Rate"
                  value={formatPercentage(
                    reportData.attrition?.percentage || 0
                  )}
                  subtitle="This month"
                  color="red"
                />
              </div>
            </div>

            {/* Summary Table */}
            <div className="bg-white rounded-lg shadow-md p-6">
              <h3 className="text-lg font-semibold text-gray-900 mb-4">
                Summary Overview
              </h3>
              <div className="overflow-x-auto">
                <table className="min-w-full divide-y divide-gray-200">
                  <thead className="bg-gray-50">
                    <tr>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Metric
                      </th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Value
                      </th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Percentage
                      </th>
                    </tr>
                  </thead>
                  <tbody className="bg-white divide-y divide-gray-200">
                    <tr>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                        Total Headcount
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {reportData.statistics?.totalHeadcount || 0}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        100.0%
                      </td>
                    </tr>
                    <tr>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                        Contractors
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {reportData.statistics?.totalContractors || 0}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {(reportData.statistics?.totalHeadcount || 0) > 0
                          ? formatPercentage(
                              ((reportData.statistics?.totalContractors || 0) /
                                (reportData.statistics?.totalHeadcount || 1)) *
                                100
                            )
                          : "0.0%"}
                      </td>
                    </tr>
                    <tr>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                        Average Age
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {Math.round(
                          reportData.ageDistribution?.averageAge || 27
                        )}{" "}
                        years
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        -
                      </td>
                    </tr>
                    <tr>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                        Average Tenure
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {reportData.tenure?.averageTenure || 2} years
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        -
                      </td>
                    </tr>
                    <tr>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                        Attrition Rate
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {reportData.statistics?.totalLeavers || 0}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {formatPercentage(
                          reportData.attrition?.percentage || 0
                        )}
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        )}

        {!reportData && !loading && (
          <div className="text-center py-12">
            <FaChartBar className="mx-auto h-12 w-12 text-deep-space-black/40 mb-4" />
            <h3 className="text-lg font-medium text-deep-space-black mb-2">
              No Report Data
            </h3>
            <p className="text-deep-space-black/70">
              Select a month to view the P&C Monthly Monitoring Report
            </p>
          </div>
        )}
      </main>
    </div>
  );
};

export default HRPNCMonitoring;
