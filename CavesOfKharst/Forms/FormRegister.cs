using CavesOfKharst.Controls;
using CavesOfKharst.DataAccess;
using Org.BouncyCastle.Asn1.X509;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace CavesOfKharst.Forms
{
    public partial class FormRegister : Form
    {
        private FormLogin formLogin;

        public FormRegister(FormLogin formLogin)
        {
            InitializeComponent();
            this.formLogin = formLogin;
        }

        private void formRegister_Load(object sender, EventArgs e)
        {

        }

        private void btnRegister_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text;
            string password = ctrlPassword1.password;
            string confirmPassword = ctrlPassword2.password;

            // Validate email
            if (string.IsNullOrWhiteSpace(email))
            {
                MessageBox.Show("Please enter an email.");
                return;
            }
            // Validate password
            if (string.IsNullOrWhiteSpace(password))
            {
                MessageBox.Show("Please enter a password.");
                return;
            }
            if (password != confirmPassword)
            {
                MessageBox.Show("Passwords do not match.");
                return;
            }

            // Valid registration
            UserDAO userDAO = new UserDAO();
            if (userDAO.Register(email, password))
            {
                MessageBox.Show("Registration successful!");
            }
            else
            {
                MessageBox.Show("Registration failed.");
            }
        }

        private void btnBack_Click(object sender, EventArgs e)
        {
            formLogin.Show();
            this.Close();
        }
    }
}
