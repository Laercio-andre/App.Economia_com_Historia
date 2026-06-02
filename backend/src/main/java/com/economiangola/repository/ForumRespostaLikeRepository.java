// src/main/java/com/economiangola/repository/ForumRespostaLikeRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.ForumRespostaLike;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ForumRespostaLikeRepository extends JpaRepository<ForumRespostaLike, Long> {

    Optional<ForumRespostaLike> findByForumRespostaIdAndUsuarioId(Long forumRespostaId, Long usuarioId);

    boolean existsByForumRespostaIdAndUsuarioId(Long forumRespostaId, Long usuarioId);

    long countByForumRespostaId(Long forumRespostaId);
}
