import React, { useEffect, useState } from 'react';

interface TickerItem {
  label: string;
  value: string;
  change: number; // positive, negative or zero
  prefix?: string;
  suffix?: string;
}

export const Ticker: React.FC = () => {
  const [items, setItems] = useState<TickerItem[]>([
    { label: "AOA/USD", value: "924.50", change: -0.15, suffix: " ▼" },
    { label: "PETRÓLEO BRENT", value: "82.14", change: 0.42, prefix: "$", suffix: " ▲" },
    { label: "IBV (BOLSA DE LUANDA)", value: "12,450.00", change: 0.50, suffix: " Kz ▲" },
    { label: "BNA TAXA COMPULSORIA", value: "18.50", change: 0.00, suffix: "% ▬" },
    { label: "INFLAÇÃO YOY LUANDA", value: "24.80", change: 1.20, suffix: "% ▲" },
    { label: "RESERVAS LÍQUIDAS BNA", value: "14.20", change: 2.05, prefix: "$", suffix: "B ▲" },
    { label: "AOA/EUR", value: "1,012.30", change: -0.22, suffix: " ▼" },
  ]);

  // Gently fluctuate the values of items in real-time to make it feel alive!
  useEffect(() => {
    const interval = setInterval(() => {
      setItems(prevItems =>
        prevItems.map((item, idx) => {
          // select a random item to change
          if (Math.random() > 0.4) {
            const numericValue = parseFloat(item.value.replace(/,/g, ''));
            const percentChange = (Math.random() * 0.002 - 0.001) * numericValue;
            const newValue = (numericValue + percentChange).toFixed(idx === 2 ? 0 : 2);
            
            // Format thousands separator for ID 2 (IBV Luanda)
            let formattedValue = newValue;
            if (idx === 2) {
              formattedValue = parseInt(newValue).toLocaleString('pt-AO');
            }

            const newChange = percentChange >= 0 ? Math.max(0.01, item.change + 0.02) : Math.min(-0.01, item.change - 0.02);
            const directionalSuffix = percentChange >= 0 
              ? (idx === 3 ? "% ▬" : (item.suffix?.includes("%") ? "% ▲" : (item.suffix?.includes("B") ? "B ▲" : (item.suffix?.includes("Kz") ? " Kz ▲" : " ▲"))))
              : (idx === 3 ? "% ▬" : (item.suffix?.includes("%") ? "% ▼" : (item.suffix?.includes("B") ? "B ▼" : (item.suffix?.includes("Kz") ? " Kz ▼" : " ▼"))));

            return {
              ...item,
              value: formattedValue,
              change: parseFloat(newChange.toFixed(2)),
              suffix: directionalSuffix
            };
          }
          return item;
        })
      );
    }, 4500);

    return () => clearInterval(interval);
  }, []);

  return (
    <div className="w-full bg-bordeaux-primary text-gold-light border-b border-gold-premium/40 h-10 select-none overflow-hidden flex items-center relative z-40">
      <div className="flex whitespace-nowrap animate-ticker py-2">
        {/* Render items twice to allow infinite loop marquee */}
        {[...items, ...items].map((item, index) => {
          const isUp = item.change > 0;
          const isDown = item.change < 0;
          const changeColor = isUp ? 'text-gold-bright' : isDown ? 'text-red-300' : 'text-gray-300';
          
          return (
            <div key={index} className="inline-flex items-center space-x-2 font-mono text-[11px] font-medium uppercase tracking-wider mx-12">
              <span className="opacity-80 text-white">{item.label}:</span>
              <span className="text-white font-bold">
                {item.prefix}{item.value}
              </span>
              <span className={`font-semibold ${changeColor}`}>
                {item.suffix} ({isUp ? "+" : ""}{item.change}%)
              </span>
              <span className="opacity-30 text-gold-light px-2">|</span>
            </div>
          );
        })}
      </div>
    </div>
  );
};
