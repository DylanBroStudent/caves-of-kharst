using CavesOfKharst.DataAccess;
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
    public partial class FormCharacterSelect : Form
    {

        private User user;
        private FormLogin formLogin;
        public FormCharacterSelect(User user, FormLogin formLogin)
        {
            InitializeComponent();

            lblUser.Text = $"Logged in as: {user.Email}";
            this.user = user;
            this.formLogin = formLogin;
        }

        private void btnLogout_Click(object sender, EventArgs e)
        {
            formLogin.Show();
            this.Close();
        }
    }
}
