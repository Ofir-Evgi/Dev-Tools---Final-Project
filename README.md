Joomla Docker Project
=====================

Project Description
-------------------

This project sets up a Joomla-based website using Docker containers.

**Joomla** is a content management system (CMS) that allows users to build dynamic websites. It's one of the most popular CMS platforms in the world, alongside WordPress and Drupal.

The setup consists of:

-   A Joomla web server (for website content and management).

-   A MySQL server (for persistent data storage).

Both services run in isolated Docker containers and communicate over a shared Docker network.

* * * * *

Team
----

-   **Ofir Evgi**

-   **Gal Alfandary**

-   **Heelee Amitai**

* * * * *

Technologies Used
-----------------

-   🐳 **Docker & Docker Compose**

-   🌐 **Joomla CMS**

-   🗄 **MySQL Database**

-   🐚 **Shell Scripts (Bash)**

-   🐧 **Linux environment**
## Setup

Make scripts executable:
```bash
chmod +x setup.sh backup.sh restore.sh cleanup.sh
```

Start environment:
```bash
./setup.sh
```

Access the site:

-   🌍 Website: <http://localhost:8080>

-   🔧 Admin panel: <http://localhost:8080/administrator>

-   👤 Login credentials:\
    Username: `demoadmin`\
    Password: `secretpassword`

Backup Instructions
-------------------

To create a backup of the current database and content:

```bash

./backup.sh
```

This creates a timestamped backup inside the `./backups/` directory, including all mounted volumes.

* * * * *

Restore Instructions
--------------------

To restore the environment from a previous backup:

```bash

./restore.sh
```

This script loads data from the latest backup, recreates the necessary containers, and restores all persistent state.

* * * * *

Cleanup Instructions
--------------------

To tear down the environment and remove all associated containers, volumes, and network:

```bash

./cleanup.sh
```

This resets the setup to a clean slate.

* * * * *

Step-by-Step Recovery Guide
---------------------------

If you'd like to clone the project and restore the site, follow these steps:

1.  Clone the repository:

```bash

git clone https://github.com/Ofir-Evgi/Dev-Tools---Final-Project.git
cd Dev-Tools---Final-Project
```

1.  Make scripts executable:

```bash

chmod +x *.sh
```

1.  Run the setup or restore process:

```bash

./setup.sh         # To start fresh
./restore.sh       # To recover from a previous backup
```
* * * * *

Additional Notes
----------------

-   The project is designed for **Linux-based systems**, but can be adapted for macOS with Docker Desktop.

-   Logs and messages in the scripts are tailored to assist non-technical users.

-   Feel free to open issues or contribute improvements to the GitHub repo.
