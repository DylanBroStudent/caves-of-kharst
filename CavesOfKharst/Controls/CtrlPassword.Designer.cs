namespace CavesOfKharst.Controls
{
    partial class CtrlPassword
    {
        /// <summary> 
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary> 
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Component Designer generated code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            txtPassword = new TextBox();
            btnShowHide = new Button();
            SuspendLayout();
            // 
            // txtPassword
            // 
            txtPassword.Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right;
            txtPassword.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            txtPassword.Location = new Point(0, 0);
            txtPassword.Name = "txtPassword";
            txtPassword.PasswordChar = '*';
            txtPassword.Size = new Size(350, 35);
            txtPassword.TabIndex = 0;
            // 
            // btnShowHide
            // 
            btnShowHide.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            btnShowHide.Location = new Point(356, 0);
            btnShowHide.Name = "btnShowHide";
            btnShowHide.Size = new Size(90, 35);
            btnShowHide.TabIndex = 1;
            btnShowHide.Text = "Show";
            btnShowHide.UseVisualStyleBackColor = true;
            btnShowHide.Click += btnShowHide_Click;
            // 
            // CtrlPassword
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            Controls.Add(btnShowHide);
            Controls.Add(txtPassword);
            Name = "CtrlPassword";
            Size = new Size(446, 37);
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private TextBox txtPassword;
        private Button btnShowHide;
    }
}
