using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using SLC.Entities;

namespace SLC.Client
{
    //Dummy mock class
    public static class MessageSave
    {
        public static void TestSave()
        {
            SaveMessage("test subject", "test body", "test filters", "test teacher ID", new List<string>() { "Test teacher ID 1", "Test teacher ID 2" }, new List<string>() { "Test student 1", "Test student 2" });
        }

        public static void SaveMessage(string subject, string bodyxml, string filters, string senderTeacherID, List<string> staffRecipientIDs, List<string> studentRecipientIDs)
        {
            var db = ContextFactory.New();
            message m = new message();
            m.Body = bodyxml;
            m.Subject = subject;
            m.Filters = filters;

            foreach (var staff in staffRecipientIDs)
            {
                m.messagerecipients.Add(
                    new messagerecipient()
                    {
                        Recipient = staff,
                        RecipientType = (int)MessageRecipientType.Staff,
                        Sender = senderTeacherID
                    });
            };

            foreach (var student in studentRecipientIDs)
            {
                m.messagerecipients.Add(
                    new messagerecipient()
                    {
                        Recipient = student,
                        RecipientType = (int)MessageRecipientType.Student,
                        Sender = senderTeacherID
                    });
            };

            db.messages.AddObject(m);
            db.SaveChanges();
        }
    }


}