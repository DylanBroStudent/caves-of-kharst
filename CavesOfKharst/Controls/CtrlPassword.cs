using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace CavesOfKharst.Controls
{
    public partial class CtrlPassword : UserControl
    {
        public string password
        {
            get { return txtPassword.Text; }
        }

        public CtrlPassword()
        {
            InitializeComponent();
        }

        private void btnShowHide_Click(object sender, EventArgs e)
        {
            if (txtPassword.PasswordChar == '*')
            {
                txtPassword.PasswordChar = '\0';
                btnShowHide.Text = "Hide";
            }
            else
            {
                txtPassword.PasswordChar = '*';
                btnShowHide.Text = "Show";
            }
        }
    }
}