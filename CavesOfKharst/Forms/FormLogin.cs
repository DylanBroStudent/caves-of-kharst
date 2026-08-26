using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using CavesOfKharst.Controls;
using CavesOfKharst.DataAccess;
using CavesOfKharst.Forms;

namespace CavesOfKharst
{
    public partial class FormLogin : Form
    {
        public FormLogin()
        {
            InitializeComponent();

        }
        private void formLogin_Load(object sender, EventArgs e)
        {

        }

        private void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text;
            string password = ctrlPassword.password;

            UserDAO userDAO = new UserDAO();

            // get user
            User user = userDAO.Login(email, password);
            if (user != null)
            {
                FormCharacterSelect characterSelect = new FormCharacterSelect(user, this);
                characterSelect.Show();
                this.Hide();
            }
            else
            {
                MessageBox.Show("Login failed. Please check your email and password.");
            }
        }
        private void btnRegister_Click(object sender, EventArgs e)
        {
            FormRegister formRegister = new FormRegister(this);
            formRegister.Show();
            this.Hide();
        }
    }
}
