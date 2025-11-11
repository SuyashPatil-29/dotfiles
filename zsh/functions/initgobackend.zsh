# Go Backend Project Initializer
# Add this function to your ~/.zshrc file

initgobackend() {
    # Check if project name is provided
    if [ -z "$1" ]; then
        echo "❌ Error: Project name is required"
        echo "Usage: initgobackend <project-name>"
        return 1
    fi

    local project_name="$1"
    
    # Check if directory already exists
    if [ -d "$project_name" ]; then
        echo "❌ Error: Directory '$project_name' already exists"
        return 1
    fi

    echo "🚀 Initializing Go backend project: $project_name"
    echo ""

    # Create project root directory
    mkdir -p "$project_name"
    cd "$project_name" || return 1

    # Create directory structure
    echo "📁 Creating directory structure..."
    mkdir -p cmd/api
    mkdir -p internal/{config,models,repositories,services,controllers,middleware,routes}
    mkdir -p pkg/utils
    mkdir -p db/migrations

    echo "✅ Directories created"
    echo ""

    # Initialize go module
    echo "📦 Initializing Go module..."
    go mod init "$project_name"
    echo ""

    # Install dependencies
    echo "⬇️  Installing dependencies..."
    echo ""
    
    echo "  Installing Gin framework..."
    go get -u github.com/gin-gonic/gin
    
    echo "  Installing GORM..."
    go get -u gorm.io/gorm
    
    echo "  Installing GORM drivers..."
    go get -u gorm.io/driver/postgres
    go get -u gorm.io/driver/sqlite
    
    echo "  Installing godotenv..."
    go get -u github.com/joho/godotenv
    
    echo "  Installing JWT..."
    go get -u github.com/golang-jwt/jwt/v5
    
    echo "  Installing zerolog..."
    go get -u github.com/rs/zerolog/log
    
    echo ""
    echo "✅ All dependencies installed"
    echo ""

    # Create .env.example file
    echo "📄 Creating .env.example..."
    cat > .env.example << 'EOF'
# Server Configuration
PORT=8080
GIN_MODE=debug

# Database Configuration
DB_URL="postgresql://suyash@localhost:5432/backend"

# JWT Configuration
JWT_SECRET=your-secret-key-change-this
JWT_EXPIRY=24h

# CORS Configuration
CORS_ORIGINS=http://localhost:3000
EOF
    echo "✅ .env.example created"
    echo ""

    # Create .gitignore file
    echo "📄 Creating .gitignore..."
    cat > .gitignore << 'EOF'
# Binaries
*.exe
*.exe~
*.dll
*.so
*.dylib
bin/
dist/

# Test binary
*.test

# Output of the go coverage tool
*.out

# Go workspace file
go.work

# Environment variables
.env

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Logs
*.log

# Temporary files
tmp/
temp/
EOF
    echo "✅ .gitignore created"
    echo ""

    # Create db/db.go
    echo "📄 Creating db/db.go..."
    cat > db/db.go <<'EOF'
package db

import (
	"os"

	"github.com/joho/godotenv"
	"github.com/rs/zerolog/log"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var DB *gorm.DB

func InitDB() {
	err := godotenv.Load()
	if err != nil {
		log.Print("Failed to load .env file:", err)
	}

	dsn := os.Getenv("DB_URL")
	DB, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatal().Err(err).Msg("Failed to connect to database")
	}

	log.Info().Msg("Database connected successfully")

	// migrate the schema
	if err := DB.AutoMigrate(); err != nil {
		log.Fatal().Err(err).Msg("Failed to migrate schema")
	}
}
EOF
    
    if [ ! -f db/db.go ]; then
        echo "❌ Failed to create db/db.go"
        return 1
    fi
    echo "✅ db/db.go created"
    echo ""

    # Create cmd/main.go
    echo "📄 Creating cmd/main.go..."
    cat > cmd/main.go <<EOF
package main

import (
	"$project_name/db"

	"github.com/gin-gonic/gin"
)

func main() {
	db.InitDB()
	r := gin.Default()

	r.Run(":8080")
}
EOF
    
    if [ ! -f cmd/main.go ]; then
        echo "❌ Failed to create cmd/main.go"
        return 1
    fi
    echo "✅ cmd/main.go created"
    echo ""

    # Create README.md
    echo "📄 Creating README.md..."
    cat > README.md << EOF
# $project_name

A Go backend API built with Gin and GORM.

## Project Structure

\`\`\`
$project_name/
├── cmd/api/              # Application entry point
├── internal/             # Private application code
│   ├── config/           # Configuration management
│   ├── models/           # Data models
│   ├── repositories/     # Database operations
│   ├── services/         # Business logic
│   ├── controllers/      # HTTP handlers
│   ├── middleware/       # HTTP middleware
│   └── routes/           # Route definitions
├── pkg/utils/            # Shared utilities
├── db/migrations/        # Database migrations
├── .env                  # Environment variables (not in git)
└── .env.example          # Example environment variables
\`\`\`

## Setup

1. Copy \`.env.example\` to \`.env\` and configure your environment variables:
   \`\`\`bash
   cp .env.example .env
   \`\`\`

2. Update the database credentials in \`.env\`

3. Run the application:
   \`\`\`bash
   go run cmd/main.go
   \`\`\`

## Dependencies

- [Gin](https://github.com/gin-gonic/gin) - HTTP web framework
- [GORM](https://gorm.io/) - ORM library
- [godotenv](https://github.com/joho/godotenv) - Environment variable loader
- [JWT](https://github.com/golang-jwt/jwt) - JSON Web Token implementation

## Development

Run the application:
\`\`\`bash
go run cmd/main.go
\`\`\`

Run tests:
\`\`\`bash
go test ./...
\`\`\`

Build the application:
\`\`\`bash
go build -o bin/api cmd/main.go
\`\`\`
EOF
    echo "✅ README.md created"
    echo ""

    echo "✨ Project '$project_name' initialized successfully!"
    echo ""
    echo "📦 Created files:"
    echo "  ✓ .env.example"
    echo "  ✓ .gitignore"
    echo "  ✓ db/db.go"
    echo "  ✓ cmd/main.go"
    echo "  ✓ README.md"
    echo ""
    echo "Next steps:"
    echo "  1. cd $project_name"
    echo "  2. cp .env.example .env"
    echo "  3. Edit .env with your database configuration"
    echo "  4. Run the application: go run cmd/main.go"
    echo ""
    echo "Happy coding! 🎉"
}
