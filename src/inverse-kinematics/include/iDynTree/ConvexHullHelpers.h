/*!
 * @file  ConvexHullHelpers.h
 * @author Silvio Traversaro
 * @copyright 2017 iCub Facility - Istituto Italiano di Tecnologia
 *            Released under the terms of the LGPLv2.1 or later, see LGPL.TXT
 * @date 2017
 *
 */


#ifndef IDYNTREE_CONVEXHULLHELPERS_H
#define IDYNTREE_CONVEXHULLHELPERS_H

#include <string>
#include <vector>

#include <iDynTree/Core/MatrixDynSize.h>
#include <iDynTree/Core/Position.h>
#include <iDynTree/Core/Transform.h>
#include <iDynTree/Core/VectorDynSize.h>


namespace iDynTree
{
    /**
     * Class representing a 2D Polygon expressed in the 3D space.
     *
     * A poligon is a geomtric object consisting of a number of points (called vertices) and an equal number of line segments (called sides),
     *  namely a cyclically ordered set of points in a plane, with no three successive points collinear, together with the line segments
     *  joining consecutive pairs of the points. In other words, a polygon is closed broken line lying in a plane.
     */
    class Polygon
    {
    public:
        std::vector<Position> m_vertices;

        /**
         * Default constructor: build an invalid polygon without any vertex.
         */
        Polygon();

        /**
         * Set the number of vertices (the vertices can then be accessed with the operator()
         */
        void setNrOfVertices(size_t size);

        /**
         * Get the number of vertices in the Polygon
         * @return the number of vertices
         */
        size_t getNrOfVertices() const;

        /**
         * Check if a polygon is valid.
         *
         * The condition for the validity of the polygon are:
         * It has at least three points.
         *
         * @return true if is valid, false otherwise.
         */
        bool isValid() const;

        /**
         * Apply a transform on the polygon.
         * @return the transformed polygon.
         */
        Polygon applyTransform(const Transform & newFrame_X_oldFrame) const;

        Position& operator()(const size_t idx);
        const Position & operator()(const size_t idx) const;
    };

    /**
     * Class representing a 2D Polygon expressed in the 2D space.
     *
     */
    class Polygon2D
    {
    public:
        std::vector<Vector2> m_vertices;

        /**
         * Default constructor: build an invalid polygon without any vertex.
         */
        Polygon2D();

        /**
         * Set the number of vertices (the vertices can then be accessed with the operator()
         */
        void setNrOfVertices(size_t size);

        /**
         * Get the number of vertices in the Polygon
         * @return the number of vertices
         */
        size_t getNrOfVertices() const;

        /**
         * Check if a polygon is valid.
         *
         * The condition for the validity of the polygon are:
         * It has at least three points.
         *
         * @return true if is valid, false otherwise.
         */
        bool isValid() const;

        Vector2& operator()(const size_t idx);
        const Vector2 & operator()(const size_t idx) const;
    };

    /**
     * ConvexHullProjectionConstraint helper.
     *
     */
    class ConvexHullProjectionConstraint
    {
        /**
         * Once you compute the projected convex hull, build the A matrix and the b vector such that
         * Ax <= b iff the center of mass projection x is inside the convex hull.
         */
        void buildConstraintMatrix();

        /**
         * Flag to specify if the constraint is active or not.
         */
        bool m_isActive;
    public:
        /**
         * Set if the constraint is active or not.
         */
        void setActive(const bool isActive);

        /**
         * Get if the constraint is active or not.
         * @return true if the constraint is active, false otherwise.
         */
        bool isActive();

        /**
         * Get the number of constraints (i.e. the number rows of the matrix A).
         * @return the number of constraints.
         */
        size_t getNrOfConstraints();

        /**
         * Convex hull expressed in the 2D project constraint plane.
         *
         * This is computed by the buildConvexHull method.
         */
        Polygon2D projectedConvexHull;

        /**
         * A constraint matrix, such that Ax <= b iff the com projection x is in the convex hull.
         */
        MatrixDynSize A;

        /**
         * b vector, such that Ax <= b iff the com projection x is in the convex hull.
         */
        VectorDynSize b;

        /**
         * Projection matrix P,
         * Note that x = P*(c-o), where x is the projection and c is the 3d COM .
         */
        Matrix2x3 P;

        /**
         * Matrix obtained multiplyng the matrix A for the matrix P.
         */
        MatrixDynSize AtimesP;

        /**
         * Plane offset o
         * Note that x = P*(c-o), where x is the projection and c is the 3d COM .
         */
        iDynTree::Position o;

        /**
         * Build the projected convex hull.
         *
         * @param projectionPlaneXaxisInAbsoluteFrame X direction of the projection axis, in the absolute frame.
         * @param projectionPlaneYaxisInAbsoluteFrame Y direction of the projection axis, in the absolute frame.
         * @param supportPolygonsExpressedInSupportFrame Vector of the support polygons, expressed in the support frames.
         * @param absoluteFrame_X_supportFrame Vector of the transform between each support frame and the absolute frame.
         * @return true if all went well, false otherwise.
         */
        bool buildConvexHull(const iDynTree::Direction xAxisOfPlaneInWorld,
                             const iDynTree::Direction yAxisOfPlaneInWorld,
                             const iDynTree::Position originOfPlaneInWorld,
                             const std::vector<Polygon> & supportPolygonsExpressedInSupportFrame,
                             const std::vector<Transform> & absoluteFrame_X_supportFrame);


    };
}


#endif
