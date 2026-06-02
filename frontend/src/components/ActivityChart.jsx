import React from 'react';
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  ResponsiveContainer,
  Cell,
  Tooltip,
} from 'recharts';

const CustomBar = (props) => {
  const { x, y, width, height, fill } = props;
  const radius = 4;
  if (height <= 0) return null;
  return (
    <g>
      <rect
        x={x}
        y={y + radius}
        width={width}
        height={Math.max(height - radius, 0)}
        fill={fill}
      />
      <rect
        x={x}
        y={y}
        width={width}
        height={radius * 2}
        rx={radius}
        ry={radius}
        fill={fill}
      />
    </g>
  );
};

const CustomTooltip = ({ active, payload, label }) => {
  if (active && payload && payload.length) {
    return (
      <div className="bg-white rounded-xl shadow-lg p-3 text-xs border border-gray-100">
        <p className="font-semibold text-dark mb-1">{label}</p>
        {payload.map((entry, i) => (
          <p key={i} style={{ color: entry.color }} className="font-medium">
            {entry.name}: {entry.value}h
          </p>
        ))}
      </div>
    );
  }
  return null;
};

const ActivityChart = ({ data = [] }) => {
  const chartData = data.map((item) => ({
    month: item.month?.slice(0, 3) || '',
    Video: item.videoHours || 0,
    Practice: item.practiceHours || 0,
    Reading: item.readingHours || 0,
  }));

  const colors = {
    Video: '#1a1a2e',
    Practice: '#fde8c0',
    Reading: '#e8dff5',
  };

  return (
    <ResponsiveContainer width="100%" height={120}>
      <BarChart
        data={chartData}
        barSize={8}
        barGap={2}
        margin={{ top: 5, right: 0, left: -30, bottom: 0 }}
      >
        <XAxis
          dataKey="month"
          axisLine={false}
          tickLine={false}
          tick={{ fontSize: 10, fill: '#9ca3af' }}
          interval={1}
        />
        <YAxis hide />
        <Tooltip content={<CustomTooltip />} cursor={{ fill: 'rgba(0,0,0,0.03)' }} />
        <Bar dataKey="Video" stackId="a" fill={colors.Video} shape={<CustomBar />} name="Video" />
        <Bar dataKey="Practice" stackId="a" fill={colors.Practice} shape={<CustomBar />} name="Practice" />
        <Bar dataKey="Reading" stackId="a" fill={colors.Reading} shape={<CustomBar />} name="Reading" />
      </BarChart>
    </ResponsiveContainer>
  );
};

export default ActivityChart;
