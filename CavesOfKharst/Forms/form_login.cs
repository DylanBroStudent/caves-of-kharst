using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

using CavesOfKharst.DataAccess;

namespace CavesOfKharst
{
    public partial class form_login : Form
    {
        public form_login()
        {
            InitializeComponent();

        }

        private void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text;
            string password = txtPassword.Text;

            UserDAO userDAO = new UserDAO();

            // Call the Login method and check if the login is successful
            if (userDAO.Login(email, password))
            {
                MessageBox.Show("Login successful!");
            }
            else
            {
                MessageBox.Show("Invalid email or password.");
            }
        }
    }
}
