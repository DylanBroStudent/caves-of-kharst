namespace CavesOfKharst.Forms
{
    partial class FormRegister
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

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            txtEmail = new TextBox();
            btnRegister = new Button();
            label1 = new Label();
            label2 = new Label();
            label3 = new Label();
            label4 = new Label();
            btnBack = new Button();
            ctrlPassword1 = new CavesOfKharst.Controls.CtrlPassword();
            ctrlPassword2 = new CavesOfKharst.Controls.CtrlPassword();
            SuspendLayout();
            // 
            // txtEmail
            // 
            txtEmail.Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right;
            txtEmail.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            txtEmail.Location = new Point(26, 112);
            txtEmail.Name = "txtEmail";
            txtEmail.Size = new Size(474, 35);
            txtEmail.TabIndex = 0;
            // 
            // btnRegister
            // 
            btnRegister.Anchor = AnchorStyles.Bottom | AnchorStyles.Right;
            btnRegister.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            btnRegister.Location = new Point(335, 371);
            btnRegister.Name = "btnRegister";
            btnRegister.Size = new Size(165, 42);
            btnRegister.TabIndex = 3;
            btnRegister.Text = "Register";
            btnRegister.UseVisualStyleBackColor = true;
            btnRegister.Click += btnRegister_Click;
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            label1.Location = new Point(26, 79);
            label1.Name = "label1";
            label1.Size = new Size(63, 30);
            label1.TabIndex = 4;
            label1.Text = "Email";
            // 
            // label2
            // 
            label2.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            label2.AutoSize = true;
            label2.Font = new Font("Segoe UI", 27.75F, FontStyle.Bold, GraphicsUnit.Point, 0);
            label2.Location = new Point(174, 19);
            label2.Name = "label2";
            label2.Size = new Size(164, 50);
            label2.TabIndex = 5;
            label2.Text = "Register";
            // 
            // label3
            // 
            label3.AutoSize = true;
            label3.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            label3.Location = new Point(26, 150);
            label3.Name = "label3";
            label3.Size = new Size(99, 30);
            label3.TabIndex = 4;
            label3.Text = "Password";
            // 
            // label4
            // 
            label4.AutoSize = true;
            label4.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            label4.Location = new Point(26, 221);
            label4.Name = "label4";
            label4.Size = new Size(179, 30);
            label4.TabIndex = 4;
            label4.Text = "Confirm Password";
            // 
            // btnBack
            // 
            btnBack.Anchor = AnchorStyles.Bottom | AnchorStyles.Left;
            btnBack.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            btnBack.Location = new Point(26, 371);
            btnBack.Name = "btnBack";
            btnBack.Size = new Size(165, 42);
            btnBack.TabIndex = 3;
            btnBack.Text = "Back";
            btnBack.UseVisualStyleBackColor = true;
            btnBack.Click += btnBack_Click;
            // 
            // ctrlPassword1
            // 
            ctrlPassword1.Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right;
            ctrlPassword1.Location = new Point(26, 183);
            ctrlPassword1.Name = "ctrlPassword1";
            ctrlPassword1.Size = new Size(474, 35);
            ctrlPassword1.TabIndex = 6;
            // 
            // ctrlPassword2
            // 
            ctrlPassword2.Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right;
            ctrlPassword2.Location = new Point(26, 254);
            ctrlPassword2.Name = "ctrlPassword2";
            ctrlPassword2.Size = new Size(474, 36);
            ctrlPassword2.TabIndex = 6;
            // 
            // FormRegister
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(512, 425);
            Controls.Add(ctrlPassword2);
            Controls.Add(ctrlPassword1);
            Controls.Add(label2);
            Controls.Add(label4);
            Controls.Add(label3);
            Controls.Add(label1);
            Controls.Add(btnBack);
            Controls.Add(btnRegister);
            Controls.Add(txtEmail);
            Name = "FormRegister";
            Text = "form_register";
            Load += formRegister_Load;
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private TextBox txtEmail;
        private Button btnRegister;
        private Label label1;
        private Label label2;
        private Label label3;
        private Label label4;
        private Button btnBack;
        private Controls.CtrlPassword ctrlPassword1;
        private Controls.CtrlPassword ctrlPassword2;
    }
}