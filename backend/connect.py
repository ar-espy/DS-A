from flask import Flask, request, jsonify
from flask_cors import CORS
import pulp
import pandas as pd
from sklearn.linear_model import LinearRegression
import joblib

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Load the model and model columns in your Flask app
model = joblib.load('regression_model.pkl')
model_columns = joblib.load('model_columns.pkl')

@app.route('/optimize', methods=['POST'])
def optimize():
    data = request.get_json()

    supply = data['supply']
    demand = data['demand']
    costs = data['costs']
    weather_factors = data['weatherFactors']
    time_factors = data['timeFactors']
    day_factors = data['dayFactors']
    supplier_names = data['supplierNames']
    consumer_names = data['consumerNames']

    # Prepare the input data for prediction
    updated_costs = []
    for i in range(len(supply)):
        updated_costs.append([])
        for j in range(len(demand)):
            input_df = pd.DataFrame({
                'Time': [time_factors[i][j]],
                'Weather': [weather_factors[i][j]],
                'Day': [day_factors[i][j]]
            })

            # Encode the input data
            input_encoded = pd.get_dummies(input_df)
            input_encoded = input_encoded.reindex(columns=model_columns, fill_value=0)

            # Make the prediction
            predicted_percentage = model.predict(input_encoded)[0]

            # Update the cost matrix with the new costs
            updated_costs[i].append(costs[i][j] * (1 + predicted_percentage / 100))

    # Implement the optimization logic using PuLP here
    supply_indices = range(len(supply))
    demand_indices = range(len(demand))
    prob = pulp.LpProblem("Transportation Cost Minimization", pulp.LpMinimize)
    x = pulp.LpVariable.dicts("x", (supply_indices, demand_indices), lowBound=0, cat='Continuous')
    prob += pulp.lpSum([updated_costs[i][j] * x[i][j] for i in supply_indices for j in demand_indices])
    for i in supply_indices:
        prob += pulp.lpSum([x[i][j] for j in demand_indices]) <= supply[i], f"Supply_Constraint_{i}"
    for j in demand_indices:
        prob += pulp.lpSum([x[i][j] for i in supply_indices]) >= demand[j], f"Demand_Constraint_{j}"
    prob.solve()

    results = {
        'status': pulp.LpStatus[prob.status],
        'total_cost': round(pulp.value(prob.objective), 2),
        'plan': {f"{supplier_names[i]} to {consumer_names[j]}": round(x[i][j].varValue, 2) for i in supply_indices for j in demand_indices}
    }

    return jsonify(results)

if __name__ == '__main__':
    app.run(debug=True)