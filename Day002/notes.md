# Notes on Multitenant Architecture and Connecting MongoDB with Mongoose

## Introduction to Multitenant Architecture

Multitenant architecture enables a single application instance to serve multiple tenants (e.g., clients, organizations, or users) while ensuring data isolation and customization. Each tenant's data is kept separate for security and privacy.

### Key Concepts
- **Tenant**: An entity (e.g., a company) with its own data and settings.
- **Data Isolation**: Prevents tenants from accessing each other's data. Methods include:
  - **Separate Databases**: Each tenant has a dedicated database.
  - **Separate Schemas**: Tenants share a database but use distinct schemas/collections.
  - **Shared Schema**: Tenants share a collection, distinguished by a `tenantId` field.
- **Scalability**: Optimizes resources, reducing costs compared to single-tenant setups.
- **Customization**: Supports tenant-specific configurations (e.g., branding) without core changes.
- **Challenges**:
  - Ensuring strong data isolation.
  - Managing performance across tenants with varying loads.
  - Handling schema updates for all tenants.

### Use Cases
- SaaS platforms (e.g., Slack, Shopify).
- Enterprise software for multiple organizations.
- Applications requiring user-specific data separation.

## Connecting MongoDB Using Mongoose

Mongoose is an Object Data Modeling (ODM) library for MongoDB and Node.js, streamlining database interactions with schemas and validation.

### Prerequisites
- Node.js installed.
- MongoDB running locally or on a cloud service (e.g., MongoDB Atlas).
- Basic JavaScript and Node.js knowledge.

### Steps to Connect MongoDB with Mongoose

1. **Install Dependencies**
   Install Mongoose in your Node.js project:
   ```bash
   npm install mongoose
```

2. **Set Up Mongoose Connection**
Create a file (e.g., `db.js`) to connect to MongoDB:

```javascript
const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    const conn = await mongoose.connect('mongodb://localhost:27017/yourDatabase', {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log(`MongoDB Connected: ${conn.connection.host}`);
  } catch (error) {
    console.error(`Error: ${error.message}`);
    process.exit(1);
  }
};

module.exports = connectDB;
```

3. **Integrate with Your Application**
In your main file (e.g., `app.js`), call the connection function:
```markdown
```javascript
const express = require('express');
const connectDB = require('./db');

const app = express();

connectDB();

app.get('/', (req, res) => {
  res.send('API is running...');
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
```

4. **Define a Mongoose Schema and Model**
Create a schema and model for a collection:
```markdown
```javascript
const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
  },
  tenantId: {
    type: String, // For multitenancy in shared schema
    required: true,
  },
});

const User = mongoose.model('User', userSchema);

module.exports = User;
```

5. **Perform CRUD Operations**
Use the model to interact with the database:
```markdown
```javascript
const User = require('./models/User');

const createUser = async () => {
  try {
    const user = new User({
      name: 'John Doe',
      email: 'john@example.com',
      tenantId: 'tenant_123',
    });
    await user.save();
    console.log('User created:', user);
  } catch (error) {
    console.error('Error creating user:', error);
  }
};

createUser();
```

### Multitenancy Considerations
- **Separate Databases**: Connect to a tenant-specific database dynamically:
```markdown
```javascript
const getTenantDB = async (tenantId) => {
 const dbName = `tenant_${tenantId}`;
 return mongoose.createConnection(`mongodb://localhost:27017/${dbName}`);
};

- **Separate Schemas**: Use different collections per tenant in the same database.
- **Shared Schema**: Filter queries by `tenantId`:
```markdown
```javascript
User.find({ tenantId: 'tenant_123' });

- **Connection Management**: Use connection pooling or libraries like `mongoose-tenant` for scalability.
```
### Best Practices
- Store sensitive data (e.g., MongoDB URI) in environment variables:
```markdown
```bash
npm install dotenv

require('dotenv').config();
mongoose.connect(process.env.MONGO_URI);
```
- Handle connection errors and implement retries.
- Validate tenant data to prevent cross-tenant access.
- Monitor database performance, especially for shared schemas.

