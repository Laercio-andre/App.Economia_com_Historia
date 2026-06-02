// src/main/java/com/economiangola/repository/ComentarioLikeRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.ComentarioLike;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ComentarioLikeRepository extends JpaRepository<ComentarioLike, Long> {

    Optional<ComentarioLike> findByComentarioIdAndUsuarioId(Long comentarioId, Long usuarioId);

    boolean existsByComentarioIdAndUsuarioId(Long comentarioId, Long usuarioId);

    long countByComentarioId(Long comentarioId);
}
