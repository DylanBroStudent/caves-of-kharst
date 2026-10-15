namespace CavesOfKharst.Forms
{
    partial class FormViewInvites
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
            label1 = new Label();
            btnRefresh = new Button();
            listInvites = new FlowLayoutPanel();
            SuspendLayout();
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Font = new Font("Segoe UI", 15.75F, FontStyle.Bold, GraphicsUnit.Point, 0);
            label1.Location = new Point(12, 9);
            label1.Name = "label1";
            label1.Size = new Size(78, 30);
            label1.TabIndex = 0;
            label1.Text = "Invites";
            // 
            // btnRefresh
            // 
            btnRefresh.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            btnRefresh.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            btnRefresh.Location = new Point(317, 6);
            btnRefresh.Name = "btnRefresh";
            btnRefresh.Size = new Size(109, 37);
            btnRefresh.TabIndex = 1;
            btnRefresh.Text = "Refresh";
            btnRefresh.UseVisualStyleBackColor = true;
            btnRefresh.Click += btnRefresh_Click;
            // 
            // listInvites
            // 
            listInvites.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            listInvites.AutoScroll = true;
            listInvites.FlowDirection = FlowDirection.TopDown;
            listInvites.Location = new Point(12, 49);
            listInvites.Name = "listInvites";
            listInvites.Size = new Size(410, 200);
            listInvites.TabIndex = 2;
            listInvites.WrapContents = false;
            // 
            // FormViewInvites
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(434, 261);
            Controls.Add(listInvites);
            Controls.Add(btnRefresh);
            Controls.Add(label1);
            MinimumSize = new Size(450, 300);
            Name = "FormViewInvites";
            Text = "FormViewInvites";
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private Label label1;
        private Button btnRefresh;
        private FlowLayoutPanel listInvites;
    }
}