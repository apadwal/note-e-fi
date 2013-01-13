using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using SLC.Entities;

namespace SLC.Client
{
    public static class ContextFactory
    {
        public static casenexslcEntities New()
        {
            casenexslcEntities db = null;

            db = new casenexslcEntities(System.Configuration.ConfigurationManager.ConnectionStrings["casenexslcEntities"].ConnectionString);
            db.ContextOptions.LazyLoadingEnabled = false;
            return db;
        }
    }
}