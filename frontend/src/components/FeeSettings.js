import React, { useState } from 'react';

export function FeeSettings({ currentFee, setFee, withdrawFees }) {
  const [newFee, setNewFee] = useState('');

  const handleSetFee = () => {
    if (newFee && !isNaN(newFee)) {
      setFee(parseInt(newFee));
      setNewFee('');
    }
  };

  return (
    <div className="card mb-4">
      <div className="card-body">
        <h5 className="card-title">Fee Settings (Owner Only)</h5>
        <div className="mb-3">
          <label className="form-label">Set New Fee (0-100 = 0-10%)</label>
          <div className="input-group">
            <input
              type="number"
              className="form-control"
              min="0"
              max="100"
              value={newFee}
              onChange={(e) => setNewFee(e.target.value)}
              placeholder={currentFee.toString()}
            />
            <button 
              className="btn btn-primary"
              onClick={handleSetFee}
            >
              Update Fee
            </button>
          </div>
        </div>
        <button 
          className="btn btn-success"
          onClick={withdrawFees}
        >
          Withdraw Collected Fees
        </button>
      </div>
    </div>
  );
}
